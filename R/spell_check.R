spell_check <- function(text, language = "auto"){
  # Code adapted from https://github.com/nicucalcea/ggspell

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
