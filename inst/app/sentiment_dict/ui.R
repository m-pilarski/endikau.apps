library(shiny)
library(bslib)

`%||%` <- rlang::`%||%`

theme <- bs_add_rules(
  bs_theme(
    version="5",
    base_font=font_google("Source Serif 4"),
    code_font=font_google("IBM Plex Mono"),
    heading_font=font_google("Bebas Neue"),
    font_scale=1.25
    # preset=c(builtin_themes(), bootswatch_themes())[4]
  ),
  sass::sass_file(system.file("app", "custom.scss", package="endikau.apps"))
)

toc_content <- tags$div(
  HTML(paste0(
    "<nav id='navbar-sentiment' class='h-100 flex-column align-items-stretch pe-4 border-end'>",
    "  <nav class='nav nav-pills flex-column'>",
    "    <a class='nav-link' href='#item-1'>Sentimentanalyse</a>",
    "    <nav class='nav nav-pills flex-column'>",
    "      <a class='nav-link ms-2 my-1' href='#item-1-1'>Lexikonbasiert</a>",
    "      <nav class='nav nav-pills flex-column'>",
    # "        <a class='nav-link ms-4 my-1' href='#item-1-1-1'>Textaufbereitung</a>",
    "        <a class='nav-link ms-4 my-1' href='#item-1-1-2'>Sentimentlexika</a>",
    "        <a class='nav-link ms-4 my-1' href='#item-1-1-3'>Berechnung</a>",
    "        <a class='nav-link ms-4 my-1' href='#item-1-1-4'>Kritik</a>",
    "      </nav>",
    "      <a class='nav-link ms-2 my-1' href='#item-1-2'>Machine-Learning-Basiert</a>",
    "    </nav>",
    "  </nav>",
    "</nav>"
  )),
  width="300px"
)

input_content <- tags$div(
  tagAppendAttributes(
    shiny::textAreaInput(
      label="Beispieltext", inputId="sen_input-1", value="", rows=10,
      resize="none", width="100%"
    ),
    spellcheck="false"
  ),
  fluidRow(
    column(
      width=12,
      bslib::input_task_button(
        id="sen_random-1", class="block", label="Vorschlagen",
        icon=icon("dice"), label_busy="",
        icon_busy=tags$i(
          class="fa-solid fa-sync fa-spin", role="presentation"
        )
      )
    ),
    column(
      width=12,
      bslib::input_task_button(
        id="sen_add-1", class="block", label="Analysieren",
        icon=icon("calculator"), label_busy="",
        icon_busy=tags$i(
          class="fa-solid fa-sync fa-spin", role="presentation"
        )
      )
    )
  ),
  HTML("<br>"),
  fluidRow(
    shinyWidgets::pickerInput(
      inputId="sentidict",
      label="Sentimentlexikon",
      choices=c("SentiWS", "German Polarity Clues")
    )
  ) # ,
  # HTML("<br>"),
  # style="height: 100%;"
)

main_content <- tags$div(
  tags$div(
    tags$h2("Sentimentanalyse"),
    tags$div(
      p_de("Sentimentanalyse ist ein Verfahren der Data Science, das darauf abzielt, Meinungen, Emotionen und Einstellungen in Textdaten automatisch zu identifizieren und zu klassifizieren. Sie nutzt Techniken aus der Verarbeitung natürlicher Sprache (engl.: ", span_en("„natural language processing“") ," oder kurz NLP), um zu bestimmen, ob ein gegebener Text eine positive, negative oder neutrale Stimmung ausdrückt."),
      p_de("Unternehmen setzen Sentimentanalyse häufig ein, um Kundenfeedback aus sozialen Medien, Rezensionen oder Umfragen zu analysieren. So können sie wertvolle Einblicke in die Kundenzufriedenheit und Markttrends gewinnen. Ein Beispiel für die Anwendung ist die Überwachung von Social-Media-Kanälen, um in Echtzeit auf Kundenmeinungen zu Produkten oder Dienstleistungen reagieren zu können."),
      HTML("<br>")
    ),
    tags$div(
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
      tags$br(),
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
      #   HTML("<br>"),
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
      #   HTML("<br>"),
      #   id="item-1-1-2"
      # ),
      tags$div(
        tags$h4("Berechnung"),
        p_de("Zur Bewertung werden die Wörter des Textes mit den Einträgen im Lexikons (bspw. SentiWS oder German Polarity Clues) abgeglichen."),
        tags$br(),
        tags$div(
          fluidRow(uiOutput(outputId="sentidict_text")),
          style="max-height: 800px; width: 100%;"
        ),
        tags$br(),
        p_de("Die aggregierten Gewichte der Wörter aus dem Lexikon geben schließlich die Gesamtstimmung des Textes wieder."),
        tags$br(),
        tags$div(
          fluidRow(uiOutput(outputId="sentidict_score")),
          style="max-height: 800px; width: 100%;"
        ),
        tags$br(),
        id="item-1-1-3"
      ),
      tags$div(
        tags$h4("Kritik"),
        p_de("Die lexikonbasierte Sentimentanalyse ist aufgrund ihrer einfachen Implementierung und des geringen Bedarfs an Rechen- und Speicherkapazität besonders für kleine Unternehmen mit begrenzten Ressourcen attraktiv. Allerdings stößt sie in komplexen Szenarien schnell an ihre Grenzen, da sie Schwierigkeiten hat, den Kontext und die Mehrdeutigkeit von Wörtern korrekt zu erfassen. Eine Phrase wie „nicht schlecht“ kann beispielsweise fälschlicherweise als negativ interpretiert werden, obwohl sie im Kontext positiv gemeint ist."),
        HTML("<br>"),
        id="item-1-1-4"
      ),
      HTML("<br>"),
      id="item-1-1"
    ),
    tags$div(
      tags$h3("Machine-Learning-Basierte Sentimentanalyse"),
      p_de("Im Gegensatz zu lexikonbasierten Ansätzen bieten vortrainierte transformer-basierte Modelle, wie beispielsweise BERT (Bidirectional Encoder Representations from Transformers) und GPT (Generative Pre-trained Transformer), eine fortschrittliche Möglichkeit zur Sentimentanalyse. Diese Modelle sind auf großen Textkorpora vortrainiert und können kontextabhängige Bedeutungen erfassen, was ihnen ermöglicht, die Stimmung eines Textes mit hoher Genauigkeit zu bestimmen. Sie verwenden Mechanismen wie die Selbstaufmerksamkeit, um Beziehungen zwischen Wörtern im Text besser zu verstehen, selbst wenn diese weit voneinander entfernt sind. Dies erlaubt ihnen, subtile sprachliche Nuancen, Mehrdeutigkeiten und komplexe Sprachstrukturen zu erkennen und zu interpretieren. Ein wesentlicher Vorteil dieser Modelle ist ihre Fähigkeit, auch in unbekannten Domänen oder bei sarkastischen und ironischen Texten zuverlässige Ergebnisse zu liefern, da sie aus einer Vielzahl von Beispielen lernen. Darüber hinaus können sie ohne spezifische Lexika auskommen und sind durch Fine-Tuning flexibel an spezifische Anwendungsfälle anpassbar, was sie besonders leistungsstark und vielseitig macht."),
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
        tags$h4("Berechnung"),
        tags$div(
          fluidRow(uiOutput(outputId="germansentiment_score")),
          style="max-height: 300px; width: 100%;"
        ),
        HTML("<br>"),
        id="item-1-2-1"
      ),
      id="item-1-2"
    ),
    id="item-1",
    style="min-width=600px; max-width=600px;"
  )
)

page_fillable(
  withMathJax(),
  shinyjs::useShinyjs(),
  layout_sidebar(
    sidebar=sidebar(input_content, width="300px", position="left"),
    layout_sidebar(
      sidebar=sidebar(toc_content, open=list(desktop="always", mobile="closed"), position="right"),
      tags$div(main_content, style="padding-left: 15px; padding-right: 15px"),
      fill=TRUE,
      fillable=FALSE,
      padding=0,
      gap=0,
      tabindex="0",
      `data-bs-spy`="scroll",
      `data-bs-target`="#navbar-sentiment",
      `data-bs-smooth-scroll`="true"
    ),
    fill=TRUE,
    fillable=TRUE,
    padding=0,
    gap=0
  ),
  # tags$footer(
  #   tags$script(paste0(
  #     "$('[data-spy=\"scroll\"]').scrollspy('process');",
  #     "$('[data-spy=\"scroll\"]').on('activate.bs.scrollspy', function () {",
  #     "  var $spy = $(this).scrollspy('process')",
  #     "})"
  #   ))
  # ),
  title="sentiment app", lang="de", padding=0, gap=0, theme=theme
)# |> as.character()



