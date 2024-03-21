#' Grammar check a text
#'
#' @param text character. A character object with text to be check.
#' @param language character. Code like `en-US`, `fr-FR`, etc. Or `auto` (default) for automatic language detection.
#'
#' @return a tibble with grammar checks.
#' @export
#'
#' @examples
#' check_text("O rato roeu a roupa do rei de roma.", language = "pt-BR)
#' check_text("Bernardo climb the stairs to the castle’s ramparts.", language = "auto")
check_text <- function(text, language = "auto"){
  # Check text size (max on 20Kb)
  if(as.numeric(utils::object.size(x = text)/1000) > 20){
    cli::cli_alert_danger("The text is too long. Select a portion of it.")
    return(NULL)
  }

  # Call API
  res <- httr2::request(base_url = "https://api.languagetool.org/v2/check") |>
    httr2::req_body_form(
      `text` = text,
      `language` = language,
      `enabledOnly` = "false"
    ) |>
    httr2::req_throttle(rate = 20/60) |>
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


