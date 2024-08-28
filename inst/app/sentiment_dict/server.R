library(shiny)
library(callr)
# library(future)
# library(promises)
#
# plan(multisession)

example_review <- paste0(
  "Leider nicht erhalten. Schade, dass der Artikel bis heute noch nicht ",
  "angekommen ist. Auf mehrmaliges Nachfragen wurde mir zweimal versprochen, ",
  "dass Ersatz verschickt worden sei. Es kann schon mal vorkommen, dass eine ",
  "Sendung verloren geht, aber dass drei!!! Warensendungen innerhalb 4 Wochen ",
  "nicht ankommen, finde ich sehr verwunderlich. Geld wurde zurückerstattet."
)

function(input, output, session) {

  vals <- reactiveValues(
    sen_vec = example_review,
    sentidict_tbl = endikau.data::sentiws_tbl,
  )

  .doc_germansentiment_tbl_rct <- reactiveVal(NULL)
  .germansentiment_calculating_rct <- reactiveVal(FALSE)

  observeEvent(
    input$sentidict, {
      if(input$sentidict == "SentiWS"){
        vals$sentidict_tbl <- endikau.data::sentiws_tbl
      }
      if(input$sentidict == "German Polarity Clues"){
        vals$sentidict_tbl <- endikau.data::gerpolclu_tbl
      }
    }
  )

  observeEvent(
    input$`sen_random-1`, {
      updateTextInput(
        session=session, inputId="sen_input-1",
        value=random_review()
      )
    }
  )

  observeEvent(
    input$`sen_add-1`, {
      vals$sen_vec <- c(input$`sen_input-1`, vals$sen_vec)
    }
  )

  .doc_parse_tbl_rct <- reactive(
    vns::parse_doc_simple(.doc_str=first(vals$sen_vec))
  )

  .doc_sentidict_tbl_rct <- reactive(
    vns::calc_tok_sentidict_tbl(
      .doc_str=first(vals$sen_vec), .sentidict_tbl=vals$sentidict_tbl
    )
  )

  .germansentiment_rsess <- r_session$new(wait=TRUE)
  observe({
    .germansentiment_rsess$interrupt()
    .germansentiment_rsess$call(\(..doc_str){
      if(!exists("...germansentiment_model")){
        vns::use_vns_condaenv()
        ..germansentiment_model <<- vns::load_germansentiment_model()
      }
      vns::calc_doc_germansentiment_tbl(
        .doc_str=..doc_str, .germansentiment_model=..germansentiment_model
      )
    }, args=list(..doc_str=dplyr::first(vals$sen_vec)))
  })

  observe({
    invalidateLater(500)
    .doc_germansentiment_tbl <- purrr::pluck(
      .germansentiment_rsess$read(), "result"
    )
    if(!is.null(.doc_germansentiment_tbl)){
      .doc_germansentiment_tbl_rct(.doc_germansentiment_tbl)
    }
  })

  output$sentidict_table <- gt::render_gt({

    .table_data <- .doc_sentidict_tbl_rct()

    if(nrow(.table_data) == 0){
      NULL
    }else{

    .doc_sentidict_tbl_rct() |>
      dplyr::summarize(
        doc_text_html = stringi::stri_c(
          stringi::stri_c(
            "<span class='", tok_pol_lab, " bubble' data-toggle='tooltip' ",
            "data-placement='top' title='", tok_pol_num, "'>",
            tok_str_raw, "</span>"
          ),
          collapse=""
        ),
        doc_word_count = length(tok_str_raw),
        doc_pol_norm = sum(tok_pol_num) / doc_word_count,
        .by=doc_id
      ) |>
      dplyr::select(doc_text_html, doc_pol_norm) |>
      gt::gt() |>
      gt::cols_label(
        doc_text_html = "Text",
        # doc_word_count = "Wortanzahl",
        doc_pol_norm = "sentidictwert"
      ) |>
      gt::text_transform(
        locations=gt::cells_body(columns=tidyselect::ends_with("_html")),
        fn=function(.x){
          .x |> purrr::map_chr(\(..x){
            ..x |>
              klartext::str_convert_html() |>
              gt::html()
          })
        }
      ) |>
      gt::fmt_number(columns=doc_pol_norm) |>
      gt::cols_add(
        ` ` = purrr::map(1:n(), \(.rowid){
          gt::html(
            as.character(
              shiny::actionButton(
                inputId = paste0("delete_row", .rowid),
                label=NULL,
                icon=icon("trash-can"),
                style="padding: 0; border: none; background: none;",
                onclick="Shiny.setInputValue('delete_row', this.id, {priority: 'event'})"
              )
            )
          )
        })
      )
    }
  })

  output$sentidict_text <- renderText(

    .doc_sentidict_tbl_rct() |>
      mutate(
        tok_pol_lab =
          tok_pol_lab |>
          (`[<-`)(
            i=`&`(
              tok_pol_lab == "sen-miss",
              stringi::stri_detect_regex(tok_str, "[[:alpha:]]")
            ),
            value="sen-neu"
          ) |>
          (`[<-`)(
            i=stringi::stri_detect_regex(tok_str, "[[:space:]]"),
            value=NA_integer_
          ) |>
          vctrs::vec_fill_missing(direction="updown"),
        tok_pol_lab_interval = cumsum(
          `&`(
            tidyr::replace_na(tok_pol_lab != lag(tok_pol_lab), FALSE),
            stringi::stri_detect_regex(lag(tok_str), "[^[:space:]]")
          )
        )
      ) |>
      summarize(
        text_str = stringi::stri_trim_both(stringi::stri_c(tok_str, collapse="")),
        text_pol_lab = unique(as.character(tok_pol_lab)),
        .by=tok_pol_lab_interval
      ) |>
      mutate(
        text_pol_col = text_pol_lab |> as.character() |> case_match(
          "sen-pos-max"~"#009392",
          "sen-pos-med"~"#39b185",
          "sen-pos-min"~"#9ccb86",
          "sen-neu"~"#e9e29c",
          "sen-neg-min"~"#eeb479",
          "sen-neg-med"~"#e88471",
          "sen-neg-max"~"#cf597e",
          "sen-miss"~"#bababa"
        )
      ) |>
      purrr::transpose() |>
      purrr::map_chr(\(.tok_data){
        stringi::stri_c(
          "<span class='", .tok_data$text_pol_lab, "'>&thinsp;",
          .tok_data$text_str, "&thinsp;</span>"
        )
      }) |>
      stringi::stri_c(collapse="") |>
      (\(.x){stringi::stri_c("<p class='p-just' lang='de'>", .x, "</p>")})()

  )

  output$sentidict_score <- renderText({
    .doc_sentidict_tbl_rct() |>
      slice_min(doc_id, n=1, with_ties=TRUE) |>
      mutate(
        tok_pol_col = tok_pol_lab |> as.character() |> case_match(
          "sen-pos-max"~"#009392",
          "sen-pos-med"~"#39b185",
          "sen-pos-min"~"#9ccb86",
          "sen-neu"~"#e9e29c",
          "sen-neg-min"~"#eeb479",
          "sen-neg-med"~"#e88471",
          "sen-neg-max"~"#cf597e",
          "sen-miss"~"#bababa",
          .default=NA_character_
        )
      ) |>
      summarize(
        tok_pol_sum_str = stringi::stri_c(
          "$$ \\require{color}",
          scales::label_number(accuracy=0.001)(sum(tok_pol_num)),
          " = ",
          stringi::stri_c(
            stringi::stri_c(
              "\\colorbox{", tok_pol_col[tok_pol_num != 0], "}{",
              tok_pol_num[tok_pol_num != 0] |>
                scales::label_number(accuracy=0.001, style_positive="plus", style_negative="minus")(), # |>
                # purrr::modify_at(1, stringi::stri_replace_first_fixed, "+", ""),
              "}"
            ),
            collapse=""
          ),
          "$$"
        ) |> stringi::stri_replace_all_regex("([+−])(\\d)", "$1 $2")
      ) |>
      pull(tok_pol_sum_str) |>
      tags$span() |>
      withMathJax() |>
      as.character()
  })

  output$germansentiment_score <- renderText({
    if(!is.null(.doc_germansentiment_tbl_rct())){
      .doc_germansentiment_tbl_rct() |>
        slice_head(n=1) |>
        mutate(
          doc_class_lab =
            doc_class_lab |>
            case_match(
              "positive"~"<span class='sen-pos-med bubble'> Positive",
              "neutral"~"<span class='sen-neu bubble'> Neutrale",
              "negative"~"<span class='sen-neg-med bubble'> Negative"
            ) |>
            stringi::stri_c("Stimmung</span> ", sep=" ")
        ) |>
        summarize(
          class_prob_str = stringi::stri_c(
            doc_class_lab, " mit einer Wahrscheinlichkeit von ",
            scales::label_percent()(doc_class_prob)
          )
        ) |>
        pull(class_prob_str)
    }else{
      "... rechnet noch ..."
    }
    # "test"
  })

  output$sentidict_tbl <- gt::render_gt({
    .sentidict_smpl_tbl <<-
      vals$sentidict_tbl |>
      dplyr::slice_sample(n=10) |>
      dplyr::arrange(tok_pol_num)

    .sentidict_smpl_gt <<-
      .sentidict_smpl_tbl |>
      dplyr::slice_sample(n=10) |>
      dplyr::arrange(tok_pol_num) |>
      gt::gt()

    .sentidict_smpl_tbl |>
      tibble::rowid_to_column() |>
      dplyr::group_by(tok_pol_lab) |>
      dplyr::group_walk(\(..gdata, ..gkeys){
        .sentidict_smpl_gt <<-
          .sentidict_smpl_gt |>
          gt::fmt(
            columns=tok_str,
            rows=..gdata$rowid,
            fns=\(...x){purrr::map_chr(...x, \(....x){
              gt::html(stringi::stri_c(
                "<span class='", ..gkeys$tok_pol_lab, " bubble'>", ....x,
                "</span>"
              ))
            })}
          )
      })

    .sentidict_smpl_gt

  })

}

# output$accordion <- renderUI({
#
#   .accordion_tbl <-
#     .doc_sentidict_tbl_rct() |>
#     dplyr::summarize(
#       doc_text_html = stringi::stri_c(
#         stringi::stri_c(
#           "<span class='", tok_pol_lab, " bubble' data-toggle='tooltip' ",
#           "data-placement='top' title='", tok_pol_num, "'>",
#           tok_str_raw, "</span>"
#         ),
#         collapse=""
#       ),
#       doc_word_count = length(tok_str_raw),
#       doc_pol_norm = sum(tok_pol_num) / doc_word_count,
#       .by=doc_id
#     ) |>
#     mutate(
#       doc_panel = list(
#         accordion_panel(
#           title=HTML(stringi::stri_c(
#             "<table style='width:100%'><tr>",
#             "  <td width=80%>", doc_text_html, "</td>",
#             "  <td>",
#             scales::label_number(
#               accuracy=1e-3, drop0trailing=FALSE
#             )(doc_pol_norm),
#             "  </td>",
#             "  <td>",
#             as.character(shiny::actionButton(
#               inputId = paste0("delete_row", doc_id),
#               label=NULL,
#               icon=icon("trash-can"),
#               style="padding: 0; border: none; background: none;",
#               onclick=stringi::stri_c(
#                 "Shiny.setInputValue(",
#                 "  'delete_row', this.id, {priority: 'event'}",
#                 ")"
#               )
#             )),
#             "  </td>",
#             "<tr></table>"
#           )),
#           HTML(as.character(
#             withMathJax("$$a^2 + b^2 = c^2$$")
#           #   # stringi::stri_rand_lipsum(n_paragraphs=1),
#           #   # style="font-size:1rem; --bs-body-font-size:1rem;"
#           ))
#         )
#       ),
#       .by=doc_id
#     )
#
#   HTML(as.character(accordion(!!!.accordion_tbl$doc_panel, multiple=FALSE)))
#
# })

# output$parse_spacy_table <- gt::render_gt({
#
#   .table_data <- .doc_parse_spacy_tbl_rct() |> slice_min(doc_id, n=1)
#
#   if(nrow(.table_data) == 0){
#     NULL
#   }else{
#     .table_data |>
#       mutate(across(everything(), as.character)) |>
#       relocate(tok_str, .before=0) |>
#       tibble::rowid_to_column("rowid") |>
#       tibble::column_to_rownames("rowid") |>
#       as.matrix() |>
#       t() |>
#       tibble::as_tibble(rownames="feature") |>
#       gt::gt() |>
#       gt::tab_style(
#         style = list(
#           # gt::cell_fill(color = "#bababa"),
#           gt::cell_borders(color="#bababa"),
#           gt::cell_text(weight = "bold")
#         ),
#         locations = gt::cells_body(rows=1)
#       ) |>
#       gt::tab_options(column_labels.hidden=TRUE) # |>
#       # gt::cols_label(
#       #   doc_text_html = "Text",
#       #   doc_pol_norm = "sentidictwert"
#       # )
#
#   }
# })

# output$parse_text <- renderText({
#
#   .table_data <- .doc_parse_tbl_rct() |> slice_min(doc_id, n=1)
#
#   if(nrow(.table_data) == 0){
#     NULL
#   }else{
#     .table_data |>
#       pull(tok_str)
#       mutate(across(everything(), as.character)) |>
#       relocate(tok_str, .before=0) |>
#       tibble::rowid_to_column("rowid") |>
#       tibble::column_to_rownames("rowid") |>
#       as.matrix() |>
#       t() |>
#       tibble::as_tibble(rownames="feature") |>
#       gt::gt() |>
#       gt::tab_style(
#         style = list(
#           # gt::cell_fill(color = "#bababa"),
#           gt::cell_borders(color="#bababa"),
#           gt::cell_text(weight = "bold")
#         ),
#         locations = gt::cells_body(rows=1)
#       ) |>
#       gt::tab_options(column_labels.hidden=TRUE)
#   }
# })
