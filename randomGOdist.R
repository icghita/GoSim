library(biomaRt)
rm(list = setdiff(ls(), lsf.str()))

gene_ids_filename <- "backround_microarray.csv"
experimental_sample_file <- "random_16_genes.csv"
experimental_samples_gos_file <- "output_insertions_gammaCop_gos.csv"
result_common_gos_file <- "output_common_gos.csv"
result_all_gos_file <- "output_all_gos.csv"
result_genes_file <- "output_used_genes.csv"
result_uncommon_gos_file <- "output_uncommon_gos_file.csv"
size_of_sample <- 16#28
num_samples <- 50

gene_ids <- read.csv(file=gene_ids_filename, header=FALSE, sep=",")
experimental_fbgns <- read.csv(file=experimental_sample_file, header=FALSE, sep=",")
experimental_go_results <- data.frame(go_id=character())
dmelanogaster_mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "dmelanogaster_gene_ensembl")

for(fbgn in experimental_fbgns$V1) {
  # aux_result <- NA
  # while(is.na(aux_result)) {
  #   aux_result <- tryCatch(getBM(attributes = c("go_id"), filters = "ensembl_gene_id",  values = fbgn, mart = dmelanogaster_mart),
  #                       error = function(cond) {return(NA)})
  #   if(!is.null(aux_result))
  #     aux_result <- NA
  # }
  aux_result <- getBM(attributes = c("go_id"), filters = "ensembl_gene_id",  values = fbgn, mart = dmelanogaster_mart)
  experimental_go_results <- rbind(experimental_go_results, aux_result)
  experimental_go_results <- unique(experimental_go_results[c("go_id")])
}
sink(experimental_samples_gos_file)
for(i in 1:length(experimental_go_results)) {
  for(j in 1:length(experimental_go_results[[i]])) {
    cat(c(experimental_go_results[[i]][j], "\n"))
  }
}
sink()

output_common_gos_column <- data.frame(go_id=character())
output_common_gos <- list()
output_all_gos <- list()
output_used_genes <- list()
output_uncommon_gos <- list()

for (i in 1:num_samples) {
  simulated_go_results <- data.frame(go_id=character())
  random_indexes <- runif(size_of_sample, min=0, max=NROW(gene_ids)-1)
  input_query <- gene_ids[random_indexes,]
  for (query in input_query) {
    aux_result <- getBM(attributes = c( "go_id"), filters = "ensembl_gene_id",  values = query, mart = dmelanogaster_mart)
    simulated_go_results <- rbind(simulated_go_results, aux_result)
    simulated_go_results <- unique(simulated_go_results[c("go_id")])
  }
  
  all_gos_list <- list(c(length(simulated_go_results[,c("go_id")]), simulated_go_results[,c("go_id")]))
  output_all_gos <- append(output_all_gos, all_gos_list)
  all_gos_list <- list()
  
  common_gos_column <- intersect(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  common_gos_list <- list(c(length(common_gos_column), common_gos_column))
  output_common_gos <- append(output_common_gos, common_gos_list)
  common_gos_list <- list()
  
  if(!(exists("previous_uncommon_gos")))
    previous_uncommon_gos <- setdiff(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  next_uncommon_gos <- setdiff(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  output_uncommon_gos <- intersect(previous_uncommon_gos, next_uncommon_gos)
  previous_uncommon_gos <- next_uncommon_gos
    
  output_used_genes <- append(output_used_genes, list(as.vector(unlist(input_query))))
}
sink(result_common_gos_file)
for(i in 1:length(output_common_gos)) {
  for(j in 1:length(output_common_gos[[i]])) {
    cat(c(output_common_gos[[i]][j], ", "))
  }
  cat("\n")
}
sink(result_all_gos_file)
for(i in 1:length(output_all_gos)) {
  for(j in 1:length(output_all_gos[[i]])) {
    cat(c(output_all_gos[[i]][j], ", "))
  }
  cat("\n")
}
sink(result_uncommon_gos_file)
for(i in 1:length(output_uncommon_gos)) {
    cat(c("0, ",output_uncommon_gos[[i]], "\n"))
}
sink(result_genes_file)
for(i in 1:length(output_used_genes)) {
  for(j in 1:length(output_used_genes[[i]])) {
    cat(c(output_used_genes[[i]][j], ", "))
  }
  cat("\n")
}
sink()
