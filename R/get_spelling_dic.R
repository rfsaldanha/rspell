get_spelling_dic <- function(){
  # Get project spelling
  proj_spelling <- get_project_spelling_dic()

  # Prioritize project spelling over global spelling
  if(is.null(proj_spelling)){
    spelling <- get_global_spelling_dic()
  } else {
    spelling <- proj_spelling
  }

  return(spelling)
}
