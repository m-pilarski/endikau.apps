library(shiny)

function(input, output, session) {

  vals <- reactiveValues(
    sen_vec = character(),
    # sen_vec = c("ich mag das nicht", "das gefällt mir"),
    senti_dict_tbl = endikau.data::sentiws_tbl
  )

  observeEvent(
    input$senti_dict, {
      if(input$senti_dict == "SentiWS"){
        vals$senti_dict_tbl <- endikau.data::sentiws_tbl
      }
      if(input$senti_dict == "German Polarity Clues"){
        vals$senti_dict_tbl <- endikau.data::gerpolclu_tbl
      }
    }
  )

  output$accordion <- renderUI({

    .accordion_tbl <-
      .doc_sentiment_tbl_rct() |>
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
    input$sen_random, {
      updateTextInput(
        session=session, inputId="sen_input",
        value=with(dplyr::slice_sample(endikau.data::amazon_review_tbl, n=1), {
          stringi::stri_c(doc_title, ": ", doc_text)
        })
      )
    }
  )

  observeEvent(
    input$sen_add, {
      vals$sen_vec <- c(input$sen_input, vals$sen_vec)
      updateTextInput(session=session, inputId="sen_input", value="")
    }
  )

  .doc_sentiment_tbl_rct <- reactive(
    calc_doc_sentiment_tbl(vals$sen_vec, .sentiment_tbl=vals$senti_dict_tbl)
  )

  observeEvent(input$delete_row, {
    idx <- as.integer(
      stringi::stri_extract_first_regex(
        input$delete_row, "(?<=delete_row)\\d+$"
      )
    )
    vals$sen_vec <- vals$sen_vec[-idx]
  })

  output$sentiment_table <- gt::render_gt({

    .table_data <- .doc_sentiment_tbl_rct()

    if(nrow(.table_data) == 0){
      NULL
    }else{

    .doc_sentiment_tbl_rct() |>
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
        doc_pol_norm = "Sentimentwert"
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

  output$senti_dict_tbl <- gt::render_gt({
    .senti_dict_smpl_tbl <<-
      vals$senti_dict_tbl |>
      dplyr::slice_sample(n=5) |>
      dplyr::arrange(tok_pol_num)

    .senti_dict_smpl_gt <<-
      .senti_dict_smpl_tbl |>
      dplyr::slice_sample(n=5) |>
      dplyr::arrange(tok_pol_num) |>
      gt::gt()

    .senti_dict_smpl_tbl |>
      tibble::rowid_to_column() |>
      dplyr::group_by(tok_pol_lab) |>
      dplyr::group_walk(\(..gdata, ..gkeys){
        .senti_dict_smpl_gt <<-
          .senti_dict_smpl_gt |>
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

    .senti_dict_smpl_gt

  })

}
