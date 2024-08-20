#' run_app_sentiment_dict
#'
#' FUNCTION_DESCRIPTION
#'
#' @param .cache_pointer a \code{cachem::cache_*} object
#'
#' @return NULL
#'
#' @examples
#' 1 + 1
#' @export
run_app_sentiment_dict <- function(.cache_pointer=NULL) {
  shiny::shinyOptions(cache_pointer=.cache_pointer)
  app_dir <- system.file("app", "sentiment_dict", package="endikau.apps")
  # shiny::runApp(app_dir, display.mode="normal")
  shiny::shinyAppDir(appDir=app_dir)
}

# shiny::shinyAppDir()
