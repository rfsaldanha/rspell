#' Check current selection
#'
#' Check for grammar errors at the current document text selection and provide alterations suggestions if available.
#'
#' @param ask_modify logical.
#' @param language code like en-US, fr-FR, etc
#'
#' @return nothing.
#' @export
check_selection <- function(ask_modify = TRUE, language = NULL){
  # If language is not defined, try to use the project's default language
  if(is.null(language)){
    language <- get_spelling()
  }

  # Get active document id
  doc_id <- rstudioapi::documentId(allowConsole = FALSE)

  # Get selected content
  selection <- rstudioapi::selectionGet(id = doc_id)

  # If selection is empty
  if(selection == ""){
    return(NULL)
  }

  # Spell check the selected content
  proof <- spell_check(text = selection$value, language = language)

  # If proof is valid
  adj <- 0
  if(length(proof) > 0){
    # For each response on proof...
    for(i in 1:nrow(proof)){
      # Original sentence
      # Replace \r with \n for the console output
      sentence <- gsub("\r", "\n", proof$context[[i]]$text)

      # Print message about error found
      error_message <- proof[[i, "message"]]
      cli::cli_h1(error_message)

      # Print the mistake
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

      # If correction exists...
      if (!is.na(proof$replacements[[i]][[1]])) {
        # Print correction
        correct_spelling <- proof$replacements[[i]][[1]]$value |> unlist()
        cli::cli_alert_success(paste0(sentence_start, cli::col_green(correct_spelling), sentence_end))

        # If user wants to modify the text
        if(ask_modify){
          # Move focus to console
          rstudioapi::executeCommand("activateConsole")

          # Ask if user agrees with the proposed modification
          res_mod <- menu_def(prompt = "Modify the document?")

          # If yes
          if(res_mod == 1){

            # List correction to be made,
            # start and end position of the correction,
            # and number of characters that were added or removed
            # after correction
            proof_tmp <- list(
              correct_spelling = correct_spelling,
              pos1 = proof[[i,"offset"]] + 1,
              pos2 = proof[[i,"offset"]] + 1 + proof[[i,"length"]],
              adj = nchar(correct_spelling) - nchar(mistake)
            )

            # For the first correction, use the original sentence
            if(i == 1){
              new_sentence <- paste0(
                substring(selection$value, 0, proof_tmp$pos1-1),
                proof_tmp$correct_spelling,
                substring(selection$value, proof_tmp$pos2, nchar(selection$value))
              )

              adj = adj + proof_tmp$adj
            } else {
              # For the other corrections, use the last altered sentence and adjuste the position
              new_sentence <- paste0(
                substring(new_sentence, 0 + adj, proof_tmp$pos1-1 + adj),
                proof_tmp$correct_spelling,
                substring(new_sentence, proof_tmp$pos2 + adj, nchar(selection$value))
              )

              adj = adj + proof_tmp$adj
            }

            # Change the document content
            rstudioapi::selectionSet(value = new_sentence, id = doc_id)

          } else {
            new_sentence <- selection$value
          }

          # Move focus to source
          rstudioapi::executeCommand("activateSource")

          cli::cli_alert_success("Done!")
        }
      }
    }
  } else {
    # Print message about no errors found
    cli::cli_alert_success("No errors found on text!")
  }
}

