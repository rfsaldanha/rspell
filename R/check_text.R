#' Grammar check a text
#'
#' @param text character. A character object with text to be check.
#' @param language character. Code like `en-US`, `fr-FR`, etc. Or `auto` (default) for automatic language detection. Use `get_languages()` to get a list of supported languages at the LanguageTool API.
#'
#' @return a tibble with grammar checks.
#' @export
#'
#' @examplesIf curl::has_internet()
#' check_text("O rato roeu a roupa do rei de roma.", language = "pt-BR")
#' check_text("Bernardo climb the stairs to the castle’s ramparts.", language = "auto")
check_text <- function(text, language = "auto"){
  # Check text argument
  checkmate::assert_character(x = text)

  # Check language argument
  avail_lang <- get_languages()$longCode
  avail_lang <- c(avail_lang, "auto")
  checkmate::assert_choice(x = language, choices = avail_lang)

  # Check if internet connection is available
  if(!curl::has_internet()){
    cli::cli_abort(message = "An Internet connection is needed to connect to the LanguageTool API. Please check your Internet connection.")
  }

  # Check text size (max on 20Kb)
  if(as.numeric(utils::object.size(x = text)/1000) > 20){
    cli::cli_abort("The text is too long. Select a portion of it.")
  }

  # Call API
  res <- httr2::request(base_url = "https://api.languagetool.org/v2/check") |>
    httr2::req_body_form(
      `text` = text,
      `language` = language,
      `enabledOnly` = "false"
    ) |>
    httr2::req_retry() |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # Turn into a tibble
  res <- res$matches |>
    tibble::tibble() |>
    tidyr::unnest_wider(1)

  # Return tibble
  return(res)
}


