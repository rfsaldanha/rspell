get_global_spelling <- function(){
  # Read RStudio global settings

  if (xfun::is_windows()) {
    base <- rappdirs::user_config_dir("RStudio", appauthor = NULL)
  } else {
    base <- rappdirs::user_config_dir("rstudio", os = "unix")
  }

  res <- jsonlite::read_json(path = fs::path(base, "/rstudio-prefs.json"))

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
