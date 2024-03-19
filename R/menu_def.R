menu_def <- function(prompt, choices = c("Yes", "No"), def_pos = 1) {

  choices <- sapply(choices, cli::format_inline, USE.NAMES = FALSE)

  choices <- paste0(seq_along(choices), ": ", choices)

  choices[def_pos] <- paste(choices[def_pos], "(Default)")

  cli::cli_inform(
    c(prompt, choices)
  )

  repeat {
    selected <- readline("Selection: ")
    if (selected %in% c("0", seq_along(choices))) {
      break
    }
    if (selected == "") {
      selected <- def_pos
      break
    }
    cli::cli_inform("Enter an item from the menu, or 0 to exit")
  }

  selected <- as.integer(selected)

  return(selected)
}
