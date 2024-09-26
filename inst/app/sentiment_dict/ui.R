library(shiny)
library(bslib)

################################################################################

span_en <- purrr::partial(htmltools::tags$span, ...=, lang="en")

remove_label <- function(.element){
  .element |>
    as.character() |>
    xml2::read_xml() |>
    (\(.x){xml2::xml_remove(xml2::xml_find_first(.x, "//label")); .x})() |>
    xml2::xml_find_first("/") |>
    as.character() |>
    stringi::stri_replace_first_regex("<\\?xml[^>]+>", "") |>
    htmltools::HTML()
}

################################################################################

make_sen_input <- function(
  .text_input_id="sen_input_1", .random_button_id="sen_random_1",
  .add_button_id="sen_add_1"
){
  tags$div(
    class="grid",
    tags$div(
      class="g-col-12",
      htmltools::tagAppendAttributes(
        shiny::textAreaInput(
          label=NULL,
          inputId=.text_input_id, value=example_review,
          rows=5, resize="none", width="100%"
        ),
        spellcheck="false"
      )
    ),
    tags$div(
      class="g-col-12 g-col-md-6",
      bslib::input_task_button(
        id=.random_button_id, class="block", label="Vorschlagen",
        icon=icon("dice"), label_busy="", style="width: 100%;",
        icon_busy=tags$i(class="fa-solid fa-sync fa-spin", role="presentation")
      )
    ),
    tags$div(
      class="g-col-12 g-col-md-6",
      bslib::input_task_button(
        id=.add_button_id, class="block", label="Analysieren",
        icon=icon("calculator"), label_busy="", style="width: 100%;",
        icon_busy=tags$i(class="fa-solid fa-sync fa-spin", role="presentation")
      )
    )
  )
}

sen_input_1 <- make_sen_input(
  .text_input_id="sen_input_1", .random_button_id="sen_random_1",
  .add_button_id="sen_add_1"
)

sen_input_2 <- make_sen_input(
  .text_input_id="sen_input_2", .random_button_id="sen_random_2",
  .add_button_id="sen_add_2"
)

legend_sentiment <- tags$svg(
  width="100%", height="4rem",
  tags$image(
    href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f641.svg",
    x="000%", y="0rem", height="16", width="16", transform="translate(-00,0)",
    style="filter: grayscale(100%);"
  ),
  tags$image(
    href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f610.svg",
    x="050%", y="0rem", height="16", width="16", transform="translate(-08,0)",
    style="filter: grayscale(100%);"
  ),
  tags$image(
    href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f642.svg",
    x="100%", y="0rem", height="16", width="16", transform="translate(-16,0)",
    style="filter: grayscale(100%);"
  ),
  tags$svg(
    y="1.5rem", height="0.875rem", width="100%", viewBox="0 0 7 1", preserveAspectRatio="none",
    tags$rect(x="0", y="0", width="1.01", height="1", fill="#cf597e"),
    tags$rect(x="1", y="0", width="1.01", height="1", fill="#e88471"),
    tags$rect(x="2", y="0", width="1.01", height="1", fill="#eeb479"),
    tags$rect(x="3", y="0", width="1.01", height="1", fill="#e9e29c"),
    tags$rect(x="4", y="0", width="1.01", height="1", fill="#9ccb86"),
    tags$rect(x="5", y="0", width="1.01", height="1", fill="#39b185"),
    tags$rect(x="6", y="0", width="1", height="1.5", fill="#009392"),
  ),
  tags$svg(
    `alignment-baseline`="bottom", y="0%",
    tags$text(x="0%", y="3.5rem", `text-anchor`="start", `font-size`="0.875rem", "negativ"),
    tags$text(x="50%", y="3.5rem", `text-anchor`="middle", `font-size`="0.875rem", "neutral"),
    tags$text(x="100%", y="3.5rem", `text-anchor`="end", `font-size`="0.875rem", "positiv")
  )
)

element_intro <- tags$div(
  class="endikau-intro",
  tags$h2("Sentimentanalyse"),
  tags$div(
    "Automatisierte Erkennung von Stimmungen in Texten.", style="font-size: 1.5rem;",
  )
)

element_content <- tags$div(
  class="endikau-content mt-0",
  tags$div(
    id="einleitung", class="content-sec",
    tags$h3("Einleitung"),
    tags$p("Sentimentanalyse ist ein Verfahren der Data Science, das darauf abzielt, Meinungen, Emotionen und Einstellungen in Textdaten automatisch zu identifizieren und zu klassifizieren. Unternehmen setzen Sentimentanalyse häufig ein, um Kundenfeedback aus sozialen Medien, Rezensionen oder Umfragen zu analysieren. So können sie wertvolle Einblicke in Bereiche wie die Kundenzufriedenheit oder Markttrends gewinnen.")
  ),
  tags$div(
    id="lexikon", class="content-sec",
    tags$h3("Lexikonbasierte Senitmentanalyse"),
    # tags$div(
    #   tags$h4("Textaufbereitung"),
    #   tags$p("Der Prozess beginnt mit der Aufbereitung der Textdaten, die sowohl verschieden Schritter der Normalisierung als auch die Tokenisierung umfasst, um den Text in eine verarbeitbare Form zu bringen."),
    #   tags$div(
    #     fluidRow(
    #       gt::gt_output(outputId="parse_spacy_table"),
    #       height="100%"
    #     ),
    #     style="max-height: 300px;"
    #   ),
    #   id="item-1-1-1"
    # ),
    # tags$div(
    #   # tags$h4("Sentimentlexikon"),
    #   tags$div(
    #     fluidRow(
    #       gt::gt_output(outputId="sentidict_tbl"),
    #       HTML(
    #         # https://tilemill-project.github.io/tilemill/docs/guides/advanced-legends/
    #         "<div class='my-legend'>",
    #         "  <div class='legend-title'>Sentimentwert</div>",
    #         "  <div class='legend-scale'>",
    #         "    <ul class='legend-labels'>",
    #         "      <li><span class='sen-neg-max'></span>negativ</li>",
    #         "      <li><span class='sen-neg-med'></span></li>",
    #         "      <li><span class='sen-neg-min'></span></li>",
    #         "      <li><span class='sen-neu'></span>neutral</li>",
    #         "      <li><span class='sen-pos-min'></span></li>",
    #         "      <li><span class='sen-pos-med'></span></li>",
    #         "      <li><span class='sen-pos-max'></span>positiv</li>",
    #         "    </ul>",
    #         "  </div>",
    #         "</div>"
    #       )
    #     ),
    #     style="max-height: 800px;"
    #   ),
    #   id="item-1-1-2"
    # ),
    tags$div(
      id="lexikon-funktionsweise", class="content-sec",
      tags$h4("Funktionsweise"),
      tags$p("Die lexikonbasierte Sentimentanalyse ist die traditionelle Form des Verfahrens, bei der vorab definierte Wörterlisten, sogenannte Sentimentlexika, verwendet werden, um die Stimmung eines Textes zu bestimmen. Diese Lexika enthalten Wörter, die mit positiven oder negativen Gefühlen assoziiert sind, oft mit einem entsprechenden Gewicht, das die Stärke des Ausdrucks angibt."),
      tags$p("Zur Bewertung werden die Wörter des Textes mit den Einträgen des Lexikons (bspw. SentiWS oder German Polarity Clues) abgeglichen. Die aggregierten Gewichte der Wörter aus dem Lexikon geben schließlich die Gesamtstimmung des Textes wieder."),
      tags$pre(
        class="mermaid",
        "flowchart LR",
        "A[Text]--tokenisierung-->C[Abgleich mit<br>Sentimentlexikon]",
        "C--aggregation-->D[Sentimentwert<br>des Textes]",
        # "D-- &gt;0 -->E[fa:fa-face-smile positiv]",
        # "D-- =0 -->F[fa:fa-face-meh negativ]",
        # "D-- &lt;0 -->G[fa:fa-face-frown negativ];"
      ),
      bslib::card(
        bslib::card_header("Ausprobieren"),
        tags$div(
          class="grid",
          tags$div(class="g-col-12", sen_input_1),
          tags$div(
            class="g-col-12 g-col-md-6",
            remove_label(shinyWidgets::pickerInput(
              inputId="sentidict", label=NULL, width="100%", inline=TRUE,
              choices=c("SentiWS", "German Polarity Clues")
            ))
          )
        ),
        tags$div(
          class="grid",
          div(class="g-col-12", uiOutput(outputId="sentidict_text")),
          div(
            class="g-col-12 d-flex justify-content-center",
            div(class="g-col-12 g-col-md-6", legend_sentiment)
          ),
          div(class="g-col-12", uiOutput(outputId="sentidict_score"), style="overflow-x: scroll")
        )
      )
    ),
    tags$div(
      id="lexikon-kritik", class="content-sec",
      tags$h4("Kritik"),
      tags$p("Die lexikonbasierte Sentimentanalyse ist aufgrund ihrer einfachen Implementierung und des geringen Bedarfs an Rechen- und Speicherkapazität besonders für kleine Unternehmen mit begrenzten Ressourcen attraktiv. Allerdings stößt sie in komplexen Szenarien schnell an ihre Grenzen, da sie Schwierigkeiten hat, den Kontext und die Mehrdeutigkeit von Wörtern korrekt zu erfassen. Eine Phrase wie „nicht schlecht“ kann beispielsweise fälschlicherweise als negativ interpretiert werden, obwohl sie im Kontext positiv gemeint ist."),
    )
  ),
  tags$div(
    id="transformer",
    tags$h3("Machine-Learning-Basierte Sentimentanalyse"),
    tags$div(
      id="transformer-funktionsweise", class="content-sec",
      tags$h4("Funktionsweise"),
      tags$p("Im Gegensatz zu lexikonbasierten Ansätzen bieten vortrainierte Modelle, die auf allgemeinen Sprachmodellen wie BERT (Bidirectional Encoder Representations from Transformers) basieren, eine fortschrittliche Möglichkeit zur Sentimentanalyse. Diese Modelle lernen aus einer Vielzahl von Beispielen und liefern auch in unbekannten Domänen oder bei komplexen sprachlichen Strukturen, wie Sarkasmus, verlässlichere Ergebnisse. Sie sind nicht auf spezifische Lexika angewiesen und können durch Fine-Tuning flexibel an unterschiedliche Anwendungsfälle angepasst werden, was sie besonders leistungsstark und vielseitig macht."),
      sen_input_2,
      tags$div(
        fluidRow(uiOutput(outputId="germansentiment_score")),
        style="max-height: 300px; width: 100%;"
      )
    )
  )
)

# site_theme <-
#   bslib::bs_theme(
#     version="5",
#     # base_font=font_google("Source Serif 4"),
#     # base_font=font_google("Libre Franklin"),
#     base_font=font_google("Source Sans 3"),
#     # base_font=font_google("Open Sans"),
#     # base_font=font_google("IBM Plex Sans"),
#     # heading_font=font_google("Bebas Neue"),
#     # heading_font=font_google("Archivo Black"),
#     # heading_font=font_google("Patua One"),
#     # heading_font=font_google("Source Sans 3"),
#     # heading_font=font_google("Domine"),
#     heading_font=font_google("Source Serif 4"),
#     code_font=font_google("IBM Plex Mono"),
#     # font_scale=1.5,
#     primary="#375f7b",
#     `bslib-spacer`=0
#     # preset=c(builtin_themes(), bootswatch_themes())[4]
#   ) |>
#   bslib::bs_add_variables(
#     "enable-grid-classes"="false", "enable-cssgrid"="true"
#   ) |>
#   bs_add_rules(sass::sass_file(fs::path_package("www", "assets", "scss", "_variables.scss", package="endikau.site"))) |>
#   bs_add_rules(sass::sass_file(fs::path_package("www", "assets", "scss", "_layout.scss", package="endikau.site"))) |>
#   bs_add_rules(sass::sass_file(fs::path_package("www", "assets", "scss", "_toc.scss", package="endikau.site"))) |>
#   bs_add_rules(sass::sass_file(fs::path_package("www", "assets", "scss", "_text-style.scss", package="endikau.site"))) |>
#   bs_add_rules(sass::sass_file(fs::path_package("www", "assets", "scss", "_io.scss", package="endikau.site")))

# element_toc <- endikau.site::format_en_toc(
#   list(
#     "einleitung"="Einleitung",
#     "lexikon"="Lexikon&shy;basierte Sentiment&shy;analyse",
#     list(
#       "lexikon-funktionsweise"="Funktions&shy;weise",
#       "lexikon-kritik"="Kritik"
#     ),
#     "transformer"="Machine-Learning-Basierte Sentiment&shy;analyse",
#     list(
#       "transformer-funktionsweise"="Funktions&shy;weise"
#     )
#   )
# )
#
# element_sidebar <- tags$div(class="endikau-sidebar")
#
#
#
# page_fillable(
#   tags$head(
#     tags$style("@import url('https://fonts.googleapis.com/css2?family=Monoton&display=swap');"),
#     tags$style(stringi::stri_c(
#       ".monoton-regular {",
#       "  font-family: 'Monoton', system-ui;",
#       "  font-weight: 400;",
#       "  font-style: normal;",
#       "}"
#     )),
#     tags$style(".bslib-page-fill { padding: var(--bslib-spacer) 0; }"), # <<-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#     tags$script(src="shinyjs/inject.js"),
#     withMathJax(),
#     tags$script(src="https://cdn.jsdelivr.net/npm/@twemoji/api@latest/dist/twemoji.min.js", crossorigin="anonymous"),
#     tags$script(src="https://cdn.jsdelivr.net/npm/mermaid@11.1.0/dist/mermaid.min.js", crossorigin="anonymous"),
#     tags$script(src="https://cdn.jsdelivr.net/npm/wordcloud@1.2.2/src/wordcloud2.min.js"),
#     tags$link(href="https://cdn.jsdelivr.net/npm/wordcloud@1.2.2/bootstrap-responsive.min.css", rel="stylesheet")
#     # tags$script(src=fs::path_package("www", "assets", "vendor", "twemoji", "twemoji.min.js", package="endikau.site"), crossorigin="anonymous")
#   ),
#   tags$header(
#     class="navbar navbar-expand-lg fixed-top", style="background-color: var(--endikau-blue);", class="monoton-regular",
#     tags$nav(
#       tags$a(
#         class="navbar-brand", href="#",
#         tags$img(
#           # src=fs::path_package("www", "assets", "img", "JLU_Giessen-Logo.png", package="endikau.site"),
#           height="30", class="d-inline-block align-top", alt=""
#         ),
#         tags$span("EnDiKaU", class="navbar-text mx-2", style="color: #ffffff; font-size: 30pt")
#       )
#     )
#   ),
#   tags$div(
#     style="background-color: var(--endikau-blue);",
#     tags$div(
#       class="container-xxl mt-4",
#       tags$div(
#         class="grid",
#         tags$div(class="g-col-12 g-col-md-8 g-start-md-2", style="padding: 3rem 3rem; color: white; font-weight: bold;", element_intro),
#       )
#     )
#   ),
#   tags$section(
#     style="background: #bababa;",
#     tags$div(
#       class="container-xxl endikau-layout-content",
#       # element_intro,
#       element_sidebar,
#       element_toc,
#       element_content,
#       tabindex="0",
#       `data-bs-spy`="scroll",
#       `data-bs-target`="#page-toc",
#       `data-bs-smooth-scroll`="true"
#     )
#   ),
#   tags$div(
#     class="container-sm",
#     tags$div(
#       class="g-col-12 g-col-md-6",
#       tags$select(
#         class="form-select", `aria-label`="Default select example",
#         tags$option(selected=NA, "Open this select menu"),
#         tags$option(value="1", "One"),
#         tags$option(value="2", "Two")
#       )
#     ),
#     endikau.site::format_fa_list(
#       list(
#         "fa-solid fa-check-square"="Das ist ein Test",
#         "fa-solid fa-spinner fa-pulse sen-miss"="Das hier auch",
#         list(
#           "fa-solid fa-plus fa-spin"="Hier geht es weiter 💞"
#         )
#       )
#     )
#   ),
#   tags$script(
#     readr::read_file(fs::path_package("www", "assets", "js", "toc_height.js", package="endikau.site"))
#   ),
#   tags$script("window.onload = function() { twemoji.parse(document.body, {folder: 'svg', ext: '.svg'} ); }"),
#   tags$script("window.onload = function() { WordCloud(document.getElementById('word_cloud'), options); }"),
#   tags$script(src='https://cdn.jsdelivr.net/npm/@iframe-resizer/child', type='text/javascript', async=NA),
#   # tags$script(type="module", "import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs'"),
#   tags$footer(
#     tags$div(
#       class="container-xxl grid align-self-center",
#       tags$div(
#         class="g-col-12 g-col-md-8 g-start-md-4", style="margin-x: 1.5rem;",
#         !!!stringi::stri_rand_lipsum(2)
#       )
#     )
#   ),
#   theme=site_theme,
#   lang="de"
# )

# tags$section()

# use sections for background colors and put div containers in each section

# htmltools::tags$html(
#
# )

tags$html(
  tags$body(
    # tags$img(src="logo.png", alt="Logo"),
    tags$div(
      class="grid",
      tags$div(class="g-col-12", sen_input_1),
      tags$div(
        class="g-col-12 g-col-sm-6",
        remove_label(shinyWidgets::pickerInput(
          inputId="sentidict", label=NULL, width="100%", inline=TRUE,
          choices=c("SentiWS", "German Polarity Clues")
        ))
      )
    ),
    tags$div(
      class="grid",
      div(class="g-col-12", uiOutput(outputId="sentidict_text")),
      div(
        class="g-col-12 d-flex justify-content-center",
        div(class="g-col-12 g-col-sm-6", legend_sentiment)
      ),
      div(class="g-col-12", uiOutput(outputId="sentidict_score"), style="overflow-x: scroll")
    )
  ),
  endikau.site::html_load_fonts(),
  endikau.site::html_load_custom_sass(
    .sass=list(
      sass::sass_file(fs::path_package("endikau.site", "www", "assets", "vendor", "bootstrap", "scss", "bootstrap.scss")),
      sass::sass_file(fs::path_package("endikau.site", "www", "assets", "vendor", "bootstrap", "scss", "mixins", "_breakpoints.scss")),
      sass::sass_file(fs::path_package("endikau.site", "www", "assets", "scss", "_toc.scss")),
      sass::sass_file(fs::path_package("endikau.site", "www", "assets", "scss", "_text-style.scss")),
      sass::sass_file(fs::path_package("endikau.site", "www", "assets", "scss", "_io.scss"))
    )
  ),
  tags$script(src='https://cdn.jsdelivr.net/npm/@iframe-resizer/child', type='text/javascript', async=NA)
)
