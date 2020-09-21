# GoSim

This software retrieves from NCBI the aggregate GO's of the genes in a list provided as input. Afterwards is generates lists of random genes of the same length as the input and aggregates their GO's. The two sets of GO's are compared and the resulting output tables are:
  - output_experimental_gos contains the aggregate GO's of the input gene list
  - output_all_gos contains the aggregate GO's generated each simulation cycle by random lists of genes
  - output_comon_gos has, for each line, the intersection of the GO's from output_all_gos with those from output_experimental_gos (they are GO's common to the input and each simulation cycle)
  - output_uncommon_gos contains GO's which are not present in output_common_gos
  - output_used_genes contains, for each cycle, the list of random genes used for the simulation
