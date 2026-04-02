
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("CoSIA")

# Loading Dependencies
library(CoSIA)