get_project_spelling <- function(){
  # Active project folder
  project_folder <- rstudioapi::getActiveProject()

  # If there is no project, return `auto`
  if(is.null(project_folder)) return(NULL)

  # rproj file
  rproj_file <- list.files(
    path = project_folder,
    pattern = ".Rproj",
    ignore.case = TRUE,
    full.names = TRUE
  )[1] # use the first found file, if others are available

  # Read rproj content
  rproj_contents <- readLines(rproj_file)

  # Look for spelling dictionary
  rproj_dic <- stringr::str_subset(
    string = rproj_contents,
    pattern = "SpellingDictionary"
  )

  if(length(rproj_dic) == 0){
    # If there is no definition on project configuration,
    # return NULL
    return(NULL)
  } else {
    # Else, return the language string
    res <- stringr::str_split_1(string = rproj_dic, pattern = ":")
    res <- stringr::str_trim(string = res[2])
    res <- stringr::str_replace(
      string = res,
      pattern = "_",
      replacement = "-"
    )

    return(res)
  }

}
