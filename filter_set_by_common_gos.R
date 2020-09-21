library(biomaRt)
experimental_sample_filename <- "insertions_gammaCop.csv"
experimental_gos_by_gene <- "experimental_gos_by_gene.csv"
filtered_gammaCop_insertions <- "filtered_gammaCop_insertions2.csv"
experimental_fbgns <- read.csv(file=experimental_sample_filename, header=FALSE, sep=",")
count_intersections <- data.frame(fbgn=character(), common_gos=numeric(), stringsAsFactors=FALSE) 
experimental_gos <- read.csv(file=experimental_gos_by_gene, header=FALSE, sep=",", stringsAsFactors=FALSE)

 dmelanogaster_mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "dmelanogaster_gene_ensembl")
for(fbgn in experimental_fbgns$V1) {
  aux_result <- getBM(attributes = c("go_id"), filters = "ensembl_gene_id",  values = fbgn, mart = dmelanogaster_mart)
  experimental_gos <- append(experimental_gos, aux_result)
}
sink(experimental_gos_by_gene)
for(i in 1:length(experimental_gos)) {
  for(j in 1:length(experimental_gos[[i]] )) {
    cat(c(experimental_gos[[i]][j], ", "))
  }
  cat("\n")
}
sink()

for(i in 1:length(experimental_gos)) {
  count_gos <- 0
  if(i > 1) {
    for(j in 1:(i-1)) {
      count_gos <- count_gos + length(intersect(trimws(experimental_gos[[i]]), trimws(experimental_gos[[j]])))
    }
  }
  if(i < length(experimental_gos)) {
    for(j in (i+1):length(experimental_gos)) {
      count_gos <- count_gos + length(intersect(trimws(experimental_gos[[i]]), trimws(experimental_gos[[j]])))
    }
  }
  count_intersections[nrow(count_intersections)+1,] <- list(fbgn=as.vector(experimental_fbgns$V1[i]), common_gos=count_gos)
}
sink(filtered_gammaCop_insertions)
for(i in 1:nrow(count_intersections)) {
  cat(c(count_intersections$fbgn[i], ", ", count_intersections$common_gos[i], "\n"))
}
sink()

