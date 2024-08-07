#' run_app_sentiment_dict
#'
#' @return NULL
#' @export
#'
#' @examples
#' 1 + 1
run_app_sentiment_dict <- function() {
  app_dir <- system.file("app", "sentiment_dict", package="endikau.apps")
  # shiny::runApp(app_dir, display.mode="normal")
  shiny::shinyAppDir(appDir=app_dir)
}

# shiny::shinyAppDir()
