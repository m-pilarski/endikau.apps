library(shiny)
library(bslib)

`%||%` <- rlang::`%||%`

p_de <- purrr::partial(tags$p, ...=, class="p-just", lang="de")
span_en <- purrr::partial(tags$span, ...=, lang="en")

sen_input_1 <- tags$div(
  class="grid",
  tags$div(
    class="g-col-12",
    tagAppendAttributes(
      shiny::textAreaInput(
        label="Beispieltext", inputId="sen_input-1", value="", rows=10,
        resize="none", width="100%"
      ),
      spellcheck="false"
    )
  ),
  tags$div(
    class="g-col-12 g-col-md-6",
    bslib::input_task_button(
      id="sen_random-1", class="block", label="Vorschlagen",
      icon=icon("dice"), label_busy="", width="100%",
      icon_busy=tags$i(
        class="fa-solid fa-sync fa-spin", role="presentation"
      )
    ),
    tags$div(
      class="g-col-12 g-col-md-6",
      bslib::input_task_button(
        id="sen_add-1", class="block", label="Analysieren",
        icon=icon("calculator"), label_busy="", width="100%",
        icon_busy=tags$i(
          class="fa-solid fa-sync fa-spin", role="presentation"
        )
      )
    )
  )
)



# input_content <- tags$div(
#   HTML("<br>"),
#   fluidRow(
#     shinyWidgets::pickerInput(
#       inputId="sentidict",
#       label="Sentimentlexikon",
#       choices=c("SentiWS", "German Polarity Clues")
#     )
#   ) # ,
#   # HTML("<br>"),
#   # style="height: 100%;"
# )
legend_sentiment <- tags$svg(
  width="100%", height="4rem",
  tags$image(href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f641.svg", x="000%", y="0rem", height="15", width="15", transform="translate(-00.0,0)", style="filter: grayscale(100%);"),
  tags$image(href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f610.svg", x="050%", y="0rem", height="15", width="15", transform="translate(-07.5,0)", style="filter: grayscale(100%);"),
  tags$image(href="https://cdn.jsdelivr.net/gh/jdecked/twemoji@15.1.0/assets/svg/1f642.svg", x="100%", y="0rem", height="15", width="15", transform="translate(-15.0,0)", style="filter: grayscale(100%);"),
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
    tags$text(x="0%", y="3.5rem", `text-anchor`="start", `font-size`="0.875rem", "negative"),
    tags$text(x="50%", y="3.5rem", `text-anchor`="middle", `font-size`="0.875rem", "neutral"),
    tags$text(x="100%", y="3.5rem", `text-anchor`="end", `font-size`="0.875rem", "positive")
  )
)

element_intro <- tags$div(
  class="en-intro",
  # legend_sentiment,
  # HTML("&#128578;"),
  tags$h2("Sentimentanalyse"),
  tags$div(
    p_de("Sentimentanalyse ist ein Verfahren der Data Science, das darauf abzielt, Meinungen, Emotionen und Einstellungen in Textdaten automatisch zu identifizieren und zu klassifizieren. Unternehmen setzen Sentimentanalyse häufig ein, um Kundenfeedback aus sozialen Medien, Rezensionen oder Umfragen zu analysieren. So können sie wertvolle Einblicke in die Kundenzufriedenheit und Markttrends gewinnen."),
    HTML("<br>")
  )
)

element_content <- tags$div(
  class="en-content",
  tags$div(
    tags$div(
      id="lexikon",
      tags$h3("Lexikonbasierte Senitmentanalyse"),
      p_de("Die lexikonbasierte Sentimentanalyse ist die traditionelle Form des Verfahrens, bei der vorab definierte Wörterlisten, sogenannte Sentimentlexika, verwendet werden, um die Stimmung eines Textes zu bestimmen. Diese Lexika enthalten Wörter, die mit positiven oder negativen Gefühlen assoziiert sind, oft mit einem entsprechenden Gewicht, das die Stärke des Ausdrucks angibt."),
      # tags$div(
      #   shiny::textAreaInput(
      #     label="Beispieltext", inputId="sen_input-1", value="", rows=5,
      #     resize="none", width="100%"
      #   ),
      #   fluidRow(
      #     column(
      #       width=6,
      #       bslib::input_task_button(
      #         id="sen_random-1", class="block", label="Vorschlagen",
      #         icon=icon("dice"), label_busy="",
      #         icon_busy=tags$i(
      #           class="fa-solid fa-sync fa-spin", role="presentation"
      #         )
      #       )
      #     ),
      #     column(
      #       width=6,
      #       bslib::input_task_button(
      #         id="sen_add-1", class="block", label="Analysieren",
      #         icon=icon("calculator"), label_busy="",
      #         icon_busy=tags$i(
      #           class="fa-solid fa-sync fa-spin", role="presentation"
      #         )
      #       )
      #     )
      #   ),
      #   HTML("<br>")
      # ),
      # tags$div(
      #   tags$h4("Textaufbereitung"),
      #   p_de("Der Prozess beginnt mit der Aufbereitung der Textdaten, die sowohl verschieden Schritter der Normalisierung als auch die Tokenisierung umfasst, um den Text in eine verarbeitbare Form zu bringen."),
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
      sen_input_1,
      tags$div(
        id="lexikon-berechnung",
        tags$h4("Berechnung"),
        p_de("Zur Bewertung werden die Wörter des Textes mit den Einträgen im Lexikons (bspw. SentiWS oder German Polarity Clues) abgeglichen."),
        p_de("Die aggregierten Gewichte der Wörter aus dem Lexikon geben schließlich die Gesamtstimmung des Textes wieder."),
        tags$div(
          class="grid",
          div(class="g-col-12", uiOutput(outputId="sentidict_text")),
          div(class="g-col-12", legend_sentiment),
          div(class="g-col-12", uiOutput(outputId="sentidict_score"), style="overflow-x: scroll")
        )
      ),
      tags$div(
        id="lexikon-kritik",
        tags$h4("Kritik"),
        p_de("Die lexikonbasierte Sentimentanalyse ist aufgrund ihrer einfachen Implementierung und des geringen Bedarfs an Rechen- und Speicherkapazität besonders für kleine Unternehmen mit begrenzten Ressourcen attraktiv. Allerdings stößt sie in komplexen Szenarien schnell an ihre Grenzen, da sie Schwierigkeiten hat, den Kontext und die Mehrdeutigkeit von Wörtern korrekt zu erfassen. Eine Phrase wie „nicht schlecht“ kann beispielsweise fälschlicherweise als negativ interpretiert werden, obwohl sie im Kontext positiv gemeint ist."),
      )
    ),
    tags$div(
      id="item-1-2",
      tags$h3("Machine-Learning-Basierte ", HTML("&#128578;"), "Sentimentanalyse"),
      p_de("Im Gegensatz zu lexikonbasierten Ansätzen bieten vortrainierte transformer basierte Modelle, wie beispielsweise BERT (Bidirectional Encoder Representations from Transformers) und GPT (Generative Pre-trained Transformer), eine fortschrittliche Möglichkeit zur Sentimentanalyse. Diese Modelle sind auf großen Textkorpora vortrainiert und können kontextabhängige Bedeutungen erfassen, was ihnen ermöglicht, die Stimmung eines Textes mit hoher Genauigkeit zu bestimmen. Sie verwenden Mechanismen wie die Selbstaufmerksamkeit, um Beziehungen zwischen Wörtern im Text besser zu verstehen, selbst wenn diese weit voneinander entfernt sind. Dies erlaubt ihnen, subtile sprachliche Nuancen, Mehrdeutigkeiten und komplexe Sprachstrukturen zu erkennen und zu interpretieren. Ein wesentlicher Vorteil dieser Modelle ist ihre Fähigkeit, auch in unbekannten Domänen oder bei sarkastischen und ironischen Texten zuverlässige Ergebnisse zu liefern, da sie aus einer Vielzahl von Beispielen lernen. Darüber hinaus können sie ohne spezifische Lexika auskommen und sind durch Fine-Tuning flexibel an spezifische Anwendungsfälle anpassbar, was sie besonders leistungsstark und vielseitig macht."),
      # tags$div(
      #   # card_title("Beispieltext"),
      #   tagAppendAttributes(
      #     shiny::textAreaInput(
      #       label="Beispieltext", inputId="sen_input-278", value="", rows=5,
      #       resize="none", width="100%"
      #     ),
      #   ),
      #   fluidRow(
      #     column(
      #       width=6,
      #       bslib::input_task_button(
      #         id="sen_random-2", class="block", label="Vorschlagen",
      #         icon=icon("dice"), label_busy="",
      #         icon_busy=tags$i(
      #           class="fa-solid fa-sync fa-spin", role="presentation"
      #         ),
      #       )
      #     ),
      #     column(
      #       width=6,
      #       bslib::input_task_button(
      #         id="sen_add-2", class="block", label="Analysieren",
      #         icon=icon("calculator"), label_busy="",
      #         icon_busy=tags$i(
      #           class="fa-solid fa-sync fa-spin", role="presentation"
      #         ),
      #       )
      #     )
      #   ),
      #   HTML("<br>"),
      #   style="max-height: 600px;"
      # ),
      tags$div(
        id="item-1-2-1",
        tags$h4("Berechnung"),
        tags$div(
          fluidRow(uiOutput(outputId="germansentiment_score")),
          style="max-height: 300px; width: 100%;"
        )
      ),
    ),
    id="item-1",
    style="min-width=600px; max-width=600px;"
  )
)
#
# page_fillable(
#   withMathJax(),
#   shinyjs::useShinyjs(),
#   layout_columns(
#     tags$div(),
#     tags$div(main_content, style=""),
#     tags$div(toc_content, style="position: sticky; top: 20px;"),
#     col_widths=c(2, 6, 2),
#     tabindex="0",
#     `data-bs-spy`="scroll",
#     `data-bs-target`="#navbar-sentiment",
#     `data-bs-smooth-scroll`="true",
#     fill=TRUE,
#     fillable=FALSE
#   ),
#   fill=FALSE,
#   fillable=TRUE,
#   # tags$footer(
#   #   tags$script(paste0(
#   #     "$('[data-spy=\"scroll\"]').scrollspy('process');",
#   #     "$('[data-spy=\"scroll\"]').on('activate.bs.scrollspy', function () {",
#   #     "  var $spy = $(this).scrollspy('process')",
#   #     "})"
#   #   ))
#   # ),
#   title="sentiment app", lang="de", padding=0, gap=0, theme=theme
# )# |> as.character()


site_theme <-
  bslib::bs_theme(
    version="5",
    # base_font=font_google("Source Serif 4"),
    # base_font=font_google("Libre Franklin"),
    base_font=font_google("Source Sans 3"),
    # base_font=font_google("Open Sans"),
    # base_font=font_google("IBM Plex Sans"),
    # heading_font=font_google("Bebas Neue"),
    # heading_font=font_google("Archivo Black"),
    # heading_font=font_google("Patua One"),
    heading_font=font_google("Source Sans 3"),
    # heading_font=font_google("Source Serif 4", wght=600),
    code_font=font_google("IBM Plex Mono"),
    font_scale=1.5
    # preset=c(builtin_themes(), bootswatch_themes())[4]
  ) |>
  bslib::bs_add_variables(
    "enable-grid-classes"="false", "enable-cssgrid"="true",
  ) |>
  bs_add_rules(sass::sass_file(system.file("app", "assests", "scss", "_variables.scss", package="endikau.apps"))) |>
  bs_add_rules(sass::sass_file(system.file("app", "assests", "scss", "_layout.scss", package="endikau.apps"))) |>
  bs_add_rules(sass::sass_file(system.file("app", "assests", "scss", "_toc.scss", package="endikau.apps"))) |>
  bs_add_rules(sass::sass_file(system.file("app", "assests", "scss", "_text-style.scss", package="endikau.apps")))

element_toc <- tags$div(
  id="page-toc-container",
  class="en-toc text-body-secondary",
  tags$nav(
    id="page-toc",
    tags$ul(
      tags$li(
        tags$a(href="#lexikon", "Lexikonbasierte Sentimentanalyse"),
        tags$ul(
          tags$li(tags$a(href="#lexikon-berechnung", "Berechnung")),
          tags$li(tags$a(href="#lexikon-kritik", "Kritik"))
        ),
      ),
      tags$li(tags$a(href="#item-1-2", HTML("Machine-Learning-Basierte Sentiment&shy;analyse")))
    )
  )
)

element_sidebar <- tags$div(class="en-sidebar")

page_fillable(
  tags$head(
    tags$script(src="shinyjs/inject.js"),
    withMathJax(),
    tags$script(src="https://cdn.jsdelivr.net/npm/@twemoji/api@latest/dist/twemoji.min.js", crossorigin="anonymous")
  ),
  tags$div(
    class="container-xxl en-layout",
    element_sidebar,
    element_intro,
    element_toc,
    element_content,
    tabindex="0",
    `data-bs-spy`="scroll",
    `data-bs-target`="#page-toc",
    `data-bs-smooth-scroll`="true"
  ),
  tags$script(
    readr::read_file(system.file("app", "assests", "js", "toc_height.js", package="endikau.apps"))
  ),
  tags$script("window.onload = function() { twemoji.parse(document.body, {folder: 'svg', ext: '.svg'} ); }"),
  tags$footer(
    tags$div(
      class="container-xxl grid align-self-center",
      tags$div(
        class="g-col-12 g-col-md-8 g-start-md-3", style="margin-x: 1.5rem;",
        !!!stringi::stri_rand_lipsum(1)
      )
    )
  ),
  theme=site_theme,
  lang="de"
)

