get_user_dic <- function(){
  dic_path <- normalizePath(
    stringr::str_replace(
      string = rstudioapi::userDictionariesPath(),
      pattern = "dictionaries",
      replacement = "monitored/lists/user_dictionary"
    )
  )

  if(file.exists(dic_path)){
    return(readLines(con = dic_path))
  } else {
    return("")
  }
}
