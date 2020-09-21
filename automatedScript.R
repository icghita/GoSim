for(i in 1:6) {
  rm(list=setdiff(ls(),"i"))
  gene_ids_filename <- "background_microarray.csv"
  result_common_gos_name <- "output_common_gos.csv"
  result_all_gos_name <- "output_all_gos.csv"
  result_genes_name <- "output_used_genes.csv"
  result_uncommon_gos_name <- "output_uncommon_gos.csv"
  experimental_sample_names <- c()
  folder_names <- c()
  num_samples <- 50
  experimental_sample_filename <- experimental_sample_names[i]
  result_common_gos_file <- paste(getwd(), folder_names[i], result_common_gos_name, sep="")
  result_all_gos_file <- paste(getwd(), folder_names[i], result_all_gos_name, sep="")
  result_genes_file <- paste(getwd(), folder_names[i], result_genes_name, sep="")
  result_uncommon_gos_file <- paste(getwd(), folder_names[i], result_uncommon_gos_name, sep="")
  dir.create(paste(getwd(),folder_names[i],sep=""))
  source("randomGOdist.R")
}
