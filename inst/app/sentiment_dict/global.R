library(dplyr)
library(stringi)

`%||%` <- rlang::`%||%`

sentiws_tbl <- fst::read_fst(here::here("data/sentiws_tbl.fst"))
gerpolclu_tbl <- fst::read_fst(here::here("data/gerpolclu_tbl.fst"))
amazon_review_tbl <- fst::read_fst(here::here("data/amazon_review_tbl.fst"))

calc_doc_sentiment_tbl <- function(.doc_vec, .sentiment_tbl){
  .doc_vec %||%
    character() |> 
    tibble::as_tibble_col("doc_text_str") |> 
    tibble::rowid_to_column(var="doc_id") |> 
    dplyr::mutate(
      doc_tok_str_lst = doc_text_str |> 
        stringi::stri_split_boundaries(type="word") |> 
        purrr::map(stringi::stri_subset_charclass, "[[:alnum:]]"),
      .keep="unused"
    ) |> 
    tidyr::unnest_longer(doc_tok_str_lst, values_to="tok_str_raw") |> 
    dplyr::mutate(tok_str_prep = stringi::stri_trans_tolower(tok_str_raw)) |> 
    dplyr::left_join(
      .sentiment_tbl, by=dplyr::join_by(tok_str_prep == tok_str), 
      relationship="many-to-one", multiple="any"
    ) |> 
    dplyr::mutate(
      tok_pol_lab = tidyr::replace_na(
        tok_pol_lab, factor("sen-neu", levels=levels(tok_pol_lab))
      ),
      tok_pol_num = tidyr::replace_na(tok_pol_num, 0)
    )
}