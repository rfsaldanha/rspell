#' Get supported languages from LanguageTool API
#'
#' Returns a tibble of supported languages from LanguageTools API, with language name, code and long code.
#'
#' @return a tibble.
#' @export
#'
#' @examplesIf curl::has_internet()
#' get_languages()
get_languages <- function(){
  # Check if internet connection is available
  if(!curl::has_internet()){
    cli::cli_abort(message = "An Internet connection is needed to connect to the LanguageTools API. Please check your Internet connection.")
  }

  res <- httr2::request(base_url = "https://api.languagetool.org/v2/languages") |>
    httr2::req_retry() |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    tibble::tibble() |>
    tidyr::unnest_wider(1)

  return(res)
}
