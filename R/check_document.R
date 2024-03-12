check_document <- function(ask_modify = TRUE, language = "en-US"){
  document_content <- rstudioapi::getSourceEditorContext()

  for(l in 1:length(document_content$contents)){
    line_content <- document_content$contents[[l]]

    res <- spell_check(text = line_content, language = language)
    if(length(res) > 0){

      if(ask_modify == TRUE){

        res_mod <- utils::menu(c("Yes", "No"), title = cli::pluralize("Do you want make this {length(res)} modification{?s} on line {l}?"))
        if(res_mod == 1){
          pos <- c(l,res[[1]]$pos1,l,res[[1]]$pos2)
          rstudioapi::modifyRange(location = pos, text = res[[1]]$correct_spelling, id = document_content$id)

          adj <- 0
          if(length(res) > 1){
            for(m in 2:length(res)){
              adj = adj + res[[m-1]]$adj
              pos <- c(l,res[[m]]$pos1 + adj,l,res[[m]]$pos2 + adj)
              rstudioapi::modifyRange(location = pos, text = res[[m]]$correct_spelling, id = document_content$id)
            }
          }

        }
      }
    }
  }
}
