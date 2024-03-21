get_global_spelling_dic <- function(){
  # Read RStudio global settings
  lang <- rstudioapi::readRStudioPreference(name = "spelling_dictionary_language", default = "en_US")

  # Formatting
  lang <- stringr::str_replace(
    string = lang,
    pattern = "_",
    replacement = "-"
  )

  return(lang)
}
