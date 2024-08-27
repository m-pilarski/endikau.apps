library(dplyr)
library(stringi)
# library(future.callr)
# plan(callr)

`%||%` <- rlang::`%||%`

shinyOptions(cache_pointer=cachem::cache_mem())

addResourcePath("shinyjs", system.file("srcjs", package="shinyjs"))
addResourcePath("shinyjs", system.file("srcjs", package="shinyjs"))

while(is(try(vns::use_vns_condaenv()), "try-error")){
  vns::setup_vns_condaenv(.install_miniconda=TRUE, .create_condaenv=TRUE)
}

germansentiment_model <- vns::load_germansentiment_model()
# spacy_model <- vns::load_spacy_model()

# parse_doc_spacy_memo_full <- memoise::memoise(
#   f=purrr::partial(.f=vns::parse_doc_spacy, .spacy_model=spacy_model),
#   cache=getShinyOption("cache_pointer")
# )
#
# parse_doc_spacy_memo_each <- function(.doc_str){
#   purrr::map_dfr(.doc_str, \(..doc_str){
#     parse_doc_spacy_memo_full(..doc_str)
#   })
# }

calc_doc_germansentiment_tbl_memo_full <- memoise::memoise(
  f=purrr::partial(
    .f=vns::calc_doc_germansentiment_tbl,
    .germansentiment_model=germansentiment_model
  ),
  cache=getShinyOption("cache_pointer")
)

calc_doc_germansentiment_tbl_memo_each <- function(.doc_str){
  purrr::map_dfr(.doc_str, \(..doc_str){
    calc_doc_germansentiment_tbl_memo_full(..doc_str)
  })
}

random_review <- function(){
  with(dplyr::slice_sample(endikau.data::amazon_review_tbl, n=1), {
    stringi::stri_c(doc_title, ". ", doc_text)
  })
}

color_palette <- jsonlite::read_json(
  system.file("app", "sentiment_dict", "colors.json", package="endikau.apps")
)
