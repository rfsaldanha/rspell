spell_check <- function(text, language = "auto", ...){
  # Code adapted from https://github.com/nicucalcea/ggspell

  # Prepare data for the API call
  data = list(
    `text` = text,
    `language` = language,
    `enabledOnly` = "false",
    ...
  )

  # Call API
  proof <- httr::POST(url = "https://api.languagetool.org/v2/check",
                      body = data, encode = "form") |>
    httr::content()

  # Turn into a tibble
  proof <- proof$matches |>
    tibble::tibble() |>
    tidyr::unnest_wider(1)

  proof_list <- list()

  if (length(proof) > 0) {

    for (i in 1:nrow(proof)) {

      # Replace \r with \n for the console output
      sentence <- gsub("\r", "\n", proof$context[[i]]$text)

      error_message <- proof[[i, "message"]]

      cli::cli_h1(error_message)

      mistake <- substring(sentence,
                           proof$context[[i]]$offset + 1,
                           proof$context[[i]]$offset + proof$context[[i]]$length)

      sentence_start <- substring(sentence,
                                  0,
                                  proof$context[[i]]$offset) |>
        stringr::str_replace_all(".*\\n", "") # remove everything before and including \n

      sentence_end <-  substring(sentence,
                                 proof$context[[i]]$offset + proof$context[[i]]$length + 1,
                                 nchar(sentence)) |>
        stringr::str_replace_all("\\n.*$", "") # remove everything after and including \n

      cli::cli_alert_danger(paste0(sentence_start, cli::col_red(mistake), sentence_end))

      # Correct version if it exists
      if (!is.na(proof$replacements[[i]][[1]]$value |> unlist())) {
        correct_spelling <- proof$replacements[[i]][[1]]$value |> unlist()
        cli::cli_alert_success(paste0(sentence_start, cli::col_green(correct_spelling), sentence_end))
      }

      proof_tmp <- list(
        correct_spelling = correct_spelling,
        adj = nchar(correct_spelling) - nchar(mistake),
        pos1 = proof[[i,"offset"]] + 1,
        pos2 = proof[[i,"offset"]] + 1 + proof[[i,"length"]]
      )

      proof_list <- append(proof_list, list(proof_tmp))

    }
  }

  # Return results
  return(proof_list)

}
