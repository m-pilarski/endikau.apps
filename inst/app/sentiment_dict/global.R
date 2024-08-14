library(dplyr)
library(stringi)

`%||%` <- rlang::`%||%`

# if(!"vns_condaenv" %in% reticulate::conda_list()[["name"]]){
vns::setup_vns_condaenv(.install_conda=TRUE, .create_condaenv=TRUE)
# }

vns::use_vns_condaenv()

germansentiment_model <- vns::load_germansentiment_model()

calc_doc_germansentiment_tbl_memo_full <- memoise::memoise(
  f=purrr::partial(
    .f=vns::calc_doc_germansentiment_tbl,
    .germansentiment_model=germansentiment_model
  )
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

################################################################################
################################################################################
################################################################################

p_de <- purrr::partial(tags$p, `...`=, lang="de")
span_en <- purrr::partial(tags$span, `...`=, lang="en")
