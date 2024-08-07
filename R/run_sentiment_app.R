#' run_app_sentiment
#'
#' @return NULL
#' @export
#'
#' @examples
#' 1 + 1
run_app_sentiment <- function() {
  app_dir <- system.file("app", "sentiment", package="endikau.apps")
  # shiny::runApp(app_dir, display.mode="normal")
  shiny::shinyAppDir(appDir=app_dir)
}

# shiny::shinyAppDir()
