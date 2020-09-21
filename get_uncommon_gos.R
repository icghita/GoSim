experimental_gos_file <- "GO_experimental.csv"
count_common_gos_file <- "output_counting_common_gos.csv"
output_uncommon_gos_file <- "output_uncommon_gos.csv"

experimental_gos <- read.csv(file=experimental_gos_file, header=FALSE, sep=",")
count_common_gos <- read.csv(file=count_common_gos_file, header=FALSE, sep=",")
uncommon_gos <- list()

for(i in 1:NROW(experimental_gos)) {
  ok = 1
  for(j in 1:NROW(count_common_gos)) {
    if(trimws(as.vector(experimental_gos[i,1])) == trimws(as.vector(count_common_gos[j,1])))
      ok = 0
  }
  if(ok == 1)
    uncommon_gos[length(uncommon_gos) + 1] <- trimws(as.vector(experimental_gos[i,1]))
}
sink(output_uncommon_gos_file)
for(i in 1:length(uncommon_gos)) {
  cat(c(uncommon_gos[[i]], "0, ", "\n"))
}
sink()

