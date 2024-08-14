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
    font_scale=1.25,
    # preset=c(builtin_themes(), bootswatch_themes())[4]
  ),
  sass::sass_file(system.file("app", "custom.scss", package="endikau.apps"))
)

page_fillable(
  navset_pill_list(
    nav_item("hallo"),
    nav_item("hallo"),
    nav_item("hallo")
  ),
  withMathJax(),
  tags$h1("Sentimentanalyse"),
  tags$p("Sentimentanalyse ist ein Verfahren der Data Science, das darauf abzielt, Meinungen, Emotionen und Einstellungen in Textdaten automatisch zu identifizieren und zu klassifizieren. Sie nutzt Techniken aus der Verarbeitung natürlicher Sprache (engl.: „natural language processing“ oder kurz NLP), um zu bestimmen, ob ein gegebener Text eine positive, negative oder neutrale Stimmung ausdrückt.", lang="de"),
  tags$p("Unternehmen setzen Sentimentanalyse häufig ein, um Kundenfeedback aus sozialen Medien, Rezensionen oder Umfragen zu analysieren. So können sie wertvolle Einblicke in die Kundenzufriedenheit und Markttrends gewinnen. Ein Beispiel für die Anwendung ist die Überwachung von Social-Media-Kanälen, um in Echtzeit auf Kundenmeinungen zu Produkten oder Dienstleistungen reagieren zu können."),
  tags$h2("Lexikonbasierte Senitmentanalyse"),
  tags$p("Die lexikonbasierte Sentimentanalyse ist eine Methode, bei der vorab definierte Wörterlisten, sogenannte Sentimentlexika, verwendet werden, um die Stimmung eines Textes zu bestimmen. Diese Lexika enthalten Wörter, die mit positiven oder negativen Gefühlen assoziiert sind, oft mit einem entsprechenden Gewicht oder Score, der die Stärke des Ausdrucks angibt."),
  tags$p("Der Prozess beginnt mit der Aufbereitung der Textdaten, die sowohl verschieden Schritter der Normalisierung als auch die Tokenisierung umfasst, um den Text in eine verarbeitbare Form zu bringen."),
  card(
    card_title("Textaufbereitung"),
    fluidRow(),
    fluidRow(),
    fluidRow(),
    fill=FALSE
  ),
  tags$p("Anschließend werden die Wörter des Textes mit den Einträgen im Lexikons (bspw. SentiWS oder German Polarity Clues) abgeglichen. Die aggregierten Scores der Wörter geben schließlich die Gesamtstimmung des Textes wieder."),
  card(
    card_title("Sentimentlexika"),
    fluidRow(
      column(
        width=6,
        shinyWidgets::pickerInput(
          inputId="senti_dict",
          label="Sentimentlexicon",
          choices=c("SentiWS", "German Polarity Clues")
        ),
        tags$div(stringi::stri_rand_lipsum(n_paragraphs=1))
      ),
      column(
        width=6, gt::gt_output(outputId="senti_dict_tbl"),
      )
    ),
    fill=FALSE
  ),
  tags$p("Dieses Verfahren ist relativ einfach zu implementieren und erfordert keine umfangreichen Trainingsdaten, was es besonders für kleine Unternehmen mit begrenzten Ressourcen attraktiv macht."),
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
  tags$p("Aufgrund ihrer Einfachheit hat die lexikonbasierte Sentimentanalyse einige Schwächen. Eine der größten Herausforderungen ist der Umgang mit Kontext und Mehrdeutigkeit von Wörtern. Ein Wort wie „interessant“ kann je nach Kontext sowohl positiv als auch neutral oder negativ gemeint sein, was das Lexikon oft nicht korrekt erfasst."),
  tags$p("Außerdem kann diese Methode ironische oder sarkastische Aussagen nicht zuverlässig erkennen, da die wörtliche Bedeutung der Begriffe analysiert wird, ohne den eigentlichen Kontext zu berücksichtigen. Zudem sind Sentiment-Lexika oft nicht umfassend genug, um die Nuancen und Entwicklungen der Sprache abzubilden, was zu ungenauen Ergebnissen führen kann. Diese Schwächen können dazu führen, dass die lexikonbasierte Sentimentanalyse in komplexeren Szenarien weniger präzise ist als modellbasierte Ansätze."),
  tags$h2("Vortrainierte Transformer-Modelle für Sentimentanalyse"),
  tags$p("Im Gegensatz zu lexikonbasierten Ansätzen bieten vortrainierte transformer-basierte Modelle, wie beispielsweise BERT (Bidirectional Encoder Representations from Transformers) und GPT (Generative Pre-trained Transformer), eine fortschrittliche Möglichkeit zur Sentimentanalyse. Diese Modelle sind auf großen Textkorpora vortrainiert und können kontextabhängige Bedeutungen erfassen, was ihnen ermöglicht, die Stimmung eines Textes mit hoher Genauigkeit zu bestimmen. Sie verwenden Mechanismen wie die Selbstaufmerksamkeit, um Beziehungen zwischen Wörtern im Text besser zu verstehen, selbst wenn diese weit voneinander entfernt sind. Dies erlaubt ihnen, subtile sprachliche Nuancen, Mehrdeutigkeiten und komplexe Sprachstrukturen zu erkennen und zu interpretieren. Ein wesentlicher Vorteil dieser Modelle ist ihre Fähigkeit, auch in unbekannten Domänen oder bei sarkastischen und ironischen Texten zuverlässige Ergebnisse zu liefern, da sie aus einer Vielzahl von Beispielen lernen. Darüber hinaus können sie ohne spezifische Lexika auskommen und sind durch Fine-Tuning flexibel an spezifische Anwendungsfälle anpassbar, was sie besonders leistungsstark und vielseitig macht."),
  # gt::gt_output(outputId="sentiment_table"),
  theme=theme
)


