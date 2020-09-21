all_gos_file <- "output_all_gos.csv"
common_gos_file <- "output_common_gos.csv"
output_uncommon_gos_file <- "output_uncommon_gos.csv"

all_gos <- read.csv(file=all_gos_file, header=FALSE, sep=",")
common_gos <- read.csv(file=common_gos_file, header=FALSE, sep=",")
checked_gos <- list()
uncommon_gos <- list()

for(i in 1:NROW(all_gos)) {
  for(j in 2:NCOL(all_gos)) {
    if(!(all_gos[i,j] %in% checked_gos) && all_gos[i,j] != "") {
      checked_gos[length(checked_gos) + 1] <- as.vector(all_gos[i,j])
      ok = 1
      for(k in 1:NROW(common_gos)) {
        for(l in 2:NCOL(common_gos)) {
          if(all_gos[i,j] == common_gos[k,l]) {
            ok = 0
            break
          }
        }
        if(ok == 0)
          break
      }
      if(ok == 1)
        uncommon_gos[length(uncommon_gos) + 1] <- as.vector(all_gos[i,j])
    }
  }
}
sink(output_uncommon_gos_file)
for(i in 1:length(uncommon_gos)) {
  cat(c("0, ",uncommon_gos[[i]], "\n"))
}
sink()
