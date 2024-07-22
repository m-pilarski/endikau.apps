pallette <- jsonlite::read_json("colors.json")

library(htmltools)
library(bslib)

ui <- bslib::page_sidebar(
  title="Einsatz neuer Daten in Kommunikationszusammenhängen auf Unternehmensebene",
  sidebar = bslib::sidebar(
    bslib::nav_item(
      htmltools::tags$a(
        "Sentimentanalyse",
        # href="/sentimentanalyse",
        # class="link"
      )
    )
  ),
  bslib::layout_column_wrap(
    bslib::card(
      bslib::card_header("Sentimentanalyse"),
      bslib::card_body(
        p("This is the body."),
        p("This is still the body.")
      ),
      width=12
    )
  ),
  theme=bslib::bs_theme(
    bg=pallette$bg,
    fg=pallette$fg,
    primary=pallette$primary,
    secondary=pallette$secondary,
    success=pallette$success,
    info=pallette$info,
    warning=pallette$warning,
    danger=pallette$danger,
    base_font=bslib::font_google("Source Serif 4"),
    code_font=bslib::font_google("IBM Plex Mono"),
    heading_font=bslib::font_google("Source Serif 4")
  ),
  lang="de"
)
