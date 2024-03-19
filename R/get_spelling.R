get_spelling <- function(){
  # Get project spelling
  proj_spelling <- get_project_spelling()

  # Prioritize project spelling over global spelling
  if(is.null(proj_spelling)){
    spelling <- get_global_spelling()
  } else {
    spelling <- proj_spelling
  }

  return(spelling)
}
