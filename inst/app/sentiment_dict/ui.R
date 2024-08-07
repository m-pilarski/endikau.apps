library(shiny)
library(bslib)

`%||%` <- rlang::`%||%`

theme <- bs_add_rules( 
  bs_theme(
    # bg="#353942", 
    # fg="#e5e5e5", 
    # primary="#165a97",
    base_font=font_google("IBM Plex Sans"),
    code_font=font_google("IBM Plex Mono"),
    font_scale=1,
    # preset=c(builtin_themes(), bootswatch_themes())[4]
  ),
  sass::sass_file(here::here("custom.scss"))
)

page_fillable(
  navset_pill_list(
    nav_item("hallo"),
    nav_item("hallo"),
    nav_item("hallo")
  ),
  withMathJax(),
  tags$h2("Lexikonbasierte Senitmentanalyse"),
  # tags$p(
  #   HTML(stringi::stri_c(
  #     stringi::stri_rand_lipsum(n_paragraphs=2), 
  #     collapse="<br><br>"
  #   ))
  # ),
  card(
    card_title("Lexika"),
    fluidRow(
      column(
        width=8,
        shinyWidgets::pickerInput(
          inputId="senti_dict",
          label="Sentimentlexicon", 
          choices=c("SentiWS", "German Polarity Clues")
        ),
        tags$div(stringi::stri_rand_lipsum(n_paragraphs=1))
      ),
      column(
        width=4, gt::gt_output(outputId="senti_dict_tbl"),
      )
    ),
    fill=FALSE
  ),
  card(
    card_title("Hier ausprobieren"),
    fluidRow(
      column(
        width=4, 
        tagAppendAttributes(
          shiny::textAreaInput(
            inputId="sen_input", label="", value="", rows=5, resize="none",
            width="100%"
          )
        ),
        fluidRow(
          column(
            width=6,
            bslib::input_task_button(
              id="sen_random", label="", icon=icon("dice"), label_busy="", 
              icon_busy=icon("dice")#, style="--bs-btn-padding-y: .35em;"
            )
          ),
          column(
            width=6,
            bslib::input_task_button(
              id="sen_add", label="", icon=icon("plus"), label_busy="",
              icon_busy=icon("plus")#, style="--bs-btn-padding-y: .35em;"
            )
          )
        ),
        HTML(
          # https://tilemill-project.github.io/tilemill/docs/guides/advanced-legends/
          "<div class='my-legend'>",
          "  <div class='legend-title'>Sentimentwert</div>",
          "  <div class='legend-scale'>",
          "    <ul class='legend-labels'>",
          "      <li><span class='sen-neg-max'></span>negativ</li>",
          "      <li><span class='sen-neg-med'></span></li>",
          "      <li><span class='sen-neg-min'></span></li>",
          "      <li><span class='sen-neu'></span>neutral</li>",
          "      <li><span class='sen-pos-min'></span></li>",
          "      <li><span class='sen-pos-med'></span></li>",
          "      <li><span class='sen-pos-max'></span>positiv</li>",
          "    </ul>",
          "  </div>",
          # "  <div class='legend-source'>",
          # "    Source: <a href='#link to source'>ref...</a>",
          # "  </div>",
          "</div>"
        )
      ),
      column(
        width=8,
        uiOutput(outputId="accordion")
      )
    ),
    fill=FALSE
  ),
  # gt::gt_output(outputId="sentiment_table"),
  theme=theme
)


