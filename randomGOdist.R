library(biomaRt)

### inputs:
gene_ids_filename <- "background_microarray.csv"
experimental_sample_filename <- "experimental_gene_list.csv"
num_samples <- 100
### outputs:
result_experimental_gos_file <- "output_experimental_gos.csv"
result_common_gos_file <- "output_common_gos.csv"
result_all_gos_file <- "output_all_gos.csv"
result_genes_file <- "output_used_genes.csv"
result_uncommon_gos_file <- "output_uncommon_gos.csv"

gene_ids <- read.csv(file=gene_ids_filename, header=FALSE, sep=",")
experimental_fbgns <- read.csv(file=experimental_sample_filename, header=FALSE, sep=",")
experimental_go_results <- data.frame(go_id=character())
dmelanogaster_mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "dmelanogaster_gene_ensembl")
size_of_sample <- nrow(experimental_fbgns)

### get GOs of the experimental gene set (experimental_sample_filename)
for(fbgn in experimental_fbgns$V1) {
  tries = 0
  ok = TRUE
  while(tries < 10 && ok) {
    aux_result <- tryCatch(getBM(attributes = c("go_id"), filters = "ensembl_gene_id",  values = fbgn, mart = dmelanogaster_mart),
                           error = function(e) {ok = FALSE})
    tries <- tries+1
    if(ok)
      ok <- FALSE
    else
      ok <- TRUE
  }
  experimental_go_results <- rbind(experimental_go_results, aux_result)
  experimental_go_results <- unique(experimental_go_results[c("go_id")])
}
### print experimental file GOs
sink(result_experimental_gos_file)
for(i in 1:length(experimental_go_results)) {
  for(j in 1:length(experimental_go_results[[i]])) {
    cat(c(experimental_go_results[[i]][j], "\n"))
  }
  cat("\n")
}
sink()

output_common_gos_column <- data.frame(go_id=character())
output_common_gos <- list()
output_all_gos <- list()
output_used_genes <- list()
output_uncommon_gos <- list()

### create a number of "num_samples" lists of random genes from gene_ids_filename
### for each list, get their GOs
for (i in 1:num_samples) {
  print(paste("Iteration", i, "\n"))
  simulated_go_results <- data.frame(go_id=character())
  random_indexes <- runif(size_of_sample, min=0, max=NROW(gene_ids)-1)
  input_query <- gene_ids[random_indexes,]
  for (query in input_query) {
    tries = 0
    ok = TRUE
    while(tries < 10 && ok) {
      aux_result <- getBM(attributes = c( "go_id"), filters = "ensembl_gene_id",  values = query, mart = dmelanogaster_mart)
      tries <- tries+1
      if(ok)
        ok <- FALSE
      else
        ok <- TRUE
    }
    simulated_go_results <- rbind(simulated_go_results, aux_result)
    simulated_go_results <- unique(simulated_go_results[c("go_id")])
  }
  ### GOs of one simulated list
  all_gos_list <- list(c(length(simulated_go_results[,c("go_id")]), simulated_go_results[,c("go_id")]))
  output_all_gos <- append(output_all_gos, all_gos_list)
  all_gos_list <- list()
  ### intersection of GOs from the simlated list and the experimental one
  common_gos_column <- intersect(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  common_gos_list <- list(c(length(common_gos_column), common_gos_column))
  output_common_gos <- append(output_common_gos, common_gos_list)
  common_gos_list <- list()
  
  ### relative complement of of the experimental GOs list and the current simulated GOs list
  ### the result is intersected with the one from the previous iteration
  ### this computes the relative complement of the experimental GOs list and all the simulated GOs lists
  if(!(exists("previous_uncommon_gos")))
    previous_uncommon_gos <- setdiff(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  next_uncommon_gos <- setdiff(experimental_go_results[,c("go_id")], simulated_go_results[,c("go_id")])
  output_uncommon_gos <- intersect(previous_uncommon_gos, next_uncommon_gos)
  previous_uncommon_gos <- next_uncommon_gos
    
  ### add the genes used for the simulation in this iteration as a row
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
