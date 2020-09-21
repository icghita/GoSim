filename_gos <- "output_common_gos.csv"
result_file <- "output_counting.csv"
table_gos <- read.csv(file=filename_gos, header=FALSE, sep=",")
dictionary_gos <- list()

for(i in 1:NROW(table_gos)) {
  for(j in 2:NCOL(table_gos)) {
    if(as.character(table_gos[i,j]) == ' ' || as.character(table_gos[i,j]) == '')
      next
    else if(as.character(table_gos[i,j]) %in% names(dictionary_gos)) {
      dictionary_gos[[as.character(table_gos[i,j])]] <- dictionary_gos[[as.character(table_gos[i,j])]] + 1
    }
    else {
      dictionary_gos[[as.character(table_gos[i,j])]] <- 1
    }
  }
}
sink(result_file)
for(k in 1:length(dictionary_gos))
  cat(c(names(dictionary_gos)[[k]], ", ", dictionary_gos[[k]], "\n"))
sink()