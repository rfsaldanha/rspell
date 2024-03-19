get_global_spelling <- function(){
  # Read RStudio global settings
  res <- jsonlite::read_json(path = normalizePath(path = paste0(usethis:::rstudio_config_path(),"/rstudio-prefs.json")))

  # Isolate spelling dictionary
  if(is.null(res$spelling_dictionary_language)){
    lang <- "en_US"
  } else {
    lang <- res$spelling_dictionary_language
  }

  # Formatting
  lang <- stringr::str_replace(
    string = lang,
    pattern = "_",
    replacement = "-"
  )

  return(lang)
}
