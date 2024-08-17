library(shiny)

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
    # sen_vec = c("ich mag das nicht", "das gefällt mir"),
    sentidict_tbl = endikau.data::sentiws_tbl
  )

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

  output$accordion <- renderUI({

    .accordion_tbl <-
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
      mutate(
        doc_panel = list(
          accordion_panel(
            title=HTML(stringi::stri_c(
              "<table style='width:100%'><tr>",
              "  <td width=80%>", doc_text_html, "</td>",
              "  <td>",
              scales::label_number(
                accuracy=1e-3, drop0trailing=FALSE
              )(doc_pol_norm),
              "  </td>",
              "  <td>",
              as.character(shiny::actionButton(
                inputId = paste0("delete_row", doc_id),
                label=NULL,
                icon=icon("trash-can"),
                style="padding: 0; border: none; background: none;",
                onclick=stringi::stri_c(
                  "Shiny.setInputValue(",
                  "  'delete_row', this.id, {priority: 'event'}",
                  ")"
                )
              )),
              "  </td>",
              "<tr></table>"
            )),
            HTML(as.character(
              withMathJax("$$a^2 + b^2 = c^2$$")
            #   # stringi::stri_rand_lipsum(n_paragraphs=1),
            #   # style="font-size:1rem; --bs-body-font-size:1rem;"
            ))
          )
        ),
        .by=doc_id
      )

    HTML(as.character(accordion(!!!.accordion_tbl$doc_panel, multiple=FALSE)))

  })

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
      updateTextInput(session=session, inputId="sen_input-1", value="")
    }
  )

  .doc_parse_spacy_tbl_rct <- reactive(
    vns::parse_doc_spacy(.doc_str=first(vals$sen_vec))
  )

  .doc_sentidict_tbl_rct <- reactive(
    vns::calc_doc_tok_sentidict_tbl(
      .doc_vec=first(vals$sen_vec), .sentidict_tbl=vals$sentidict_tbl
    )
  )

  .doc_germansentiment_tbl_rct <- reactive(
    calc_doc_germansentiment_tbl_memo_each(
      .doc_str=first(vals$sen_vec)
    )
  )

  observeEvent(input$delete_row, {
    idx <- as.integer(
      stringi::stri_extract_first_regex(
        input$delete_row, "(?<=delete_row)\\d+$"
      )
    )
    vals$sen_vec <- vals$sen_vec[-idx]
  })

  observe({
    updateTextInput(
      session=session, inputId="sen_input-1",
      value=vals$sen_vec[[1]]
    )
    updateTextInput(
      session=session, inputId="sen_input-2",
      value=vals$sen_vec[[1]]
    )
  })

  output$parse_spacy_table <- gt::render_gt({

    .table_data <- .doc_parse_spacy_tbl_rct() |> slice_min(doc_id, n=1)

    if(nrow(.table_data) == 0){
      NULL
    }else{
      .table_data |>
        mutate(across(everything(), as.character)) |>
        relocate(tok_str, .before=0) |>
        tibble::rowid_to_column("rowid") |>
        tibble::column_to_rownames("rowid") |>
        as.matrix() |>
        t() |>
        tibble::as_tibble(rownames="feature") |>
        gt::gt() |>
        gt::tab_style(
          style = list(
            # gt::cell_fill(color = "#bababa"),
            gt::cell_borders(color="#bababa"),
            gt::cell_text(weight = "bold")
          ),
          locations = gt::cells_body(rows=1)
        ) |>
        gt::tab_options(column_labels.hidden=TRUE) # |>
        # gt::cols_label(
        #   doc_text_html = "Text",
        #   doc_pol_norm = "sentidictwert"
        # )

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
      slice_min(doc_id, n=1) |>
      mutate(across(where(is.factor), as.character)) |>
      purrr::transpose() |>
      purrr::map_chr(\(.tok_data){
        stringi::stri_c(
          "<span class='", .tok_data$tok_pol_lab, " bubble' data-toggle='tooltip' ",
          "data-placement='top' title='", .tok_data$tok_pol_num, "'>",
          .tok_data$tok_str_raw, "</span>"
        )
      }) |>
      stringi::stri_c(collapse="")
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
          "sen-miss"~"#bababa"
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
                scales::label_number(accuracy=0.001, style_positive="plus", style_negative="minus")() |>
                purrr::modify_at(1, stringi::stri_replace_first_fixed, "+", ""),
              "}"
            ),
            collapse=""
          ),
          "$$"
        ) |> stringi::stri_replace_all_regex("([+−])(\\d)", "$1 $2")
      ) |>
      pull(tok_pol_sum_str) |>
      (\(.x){print(.x); .x})() |>
      tags$span() |>
      withMathJax() |>
      as.character()
  })

  output$germansentiment_score <- renderText({
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

  timer <- reactive({
    # invalidate 1 minute later
    invalidateLater(1000 * 5)
    shinyjs::runjs(paste0(
      "$('[data-spy=\"scroll\"]').each(function () {",
      "  var $spy = $(this).scrollspy('refresh')",
      "})"
    ))
    message("adjusted scrollspy")
  })

}
