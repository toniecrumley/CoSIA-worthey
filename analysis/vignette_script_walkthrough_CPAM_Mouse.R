# R Script Following Steps from vignette to plot the gene expression variability
# across species common tissue types of Human and Mouse

# Install Dependencies
beginning_time <- Sys.time()
source('./analysis/functions/CoSIA_Instance.R')

# if ( 'dplyr' %in% installed.packages() )
#   remove.packages("dplyr")
# install.packages("dplyr", dependencies=TRUE)
library(dplyr)

# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("CoSIA")

# Loading Dependencies
# library(CoSIA)
devtools::load_all(".")

# Get Tissues For Species
input_species <- c("h_sapiens")
model_comparing <- c("m_musculus")
output_species <- c(model_comparing, input_species)

# From Vignette:
# NOTE: To compare across all shared tissues for your selected species,
# you can assign the getTissues output to an object as input for map_tissues
# when initializing a CoSIAn object. Was unable to do so, but was able to
# get the column "Common_Anatomical_Entity_Name" with overlapping
# tissues between the species

cat("1. Getting tissues for species to compare with human - ", model_comparing)
map_tissues <- CoSIA::getTissues(output_species)
common_tissues <- map_tissues[["Common_Anatomical_Entity_Name"]]

#
# Coefficient of Variation of Tissue
#
cat("2. Configuring CoSIA base library on data to process with human - ", model_comparing)
HumanAndAnimalModel_CoSIA <- CoSIA_Instance$new("VMA21", "h_sapiens", output_species, common_tissues, "CV_Tissue")
HumanAndAnimalModel_CoSIA$configure()

cat("3. Converting the Input Gene set and getting identifier mappings")
HumanAndAnimalModel_CoSIA$identifier_map()

# metric_type = "CV_Tissue" # Calculating gene expression variability among common tissue types between human and mouse
cat("4. Calculating the expression metrics need for Coefficient Of Variation plot for", model_comparing)
HumanAndAnimalModel_CoSIA$calculate_expression_metrics()

cat("5. Calculating the Coefficient of Variation across species for ", model_comparing)
HumanAndAnimalModel_CoSIA$calculate_coefficient_variation_plot()

HumanAndAnimalModel_CoSIA$coefficient_variation_plot

end_time <- Sys.time()

time.loop <- end_time - beginning_time
cat("Time elapsed: ", round((time.loop),3), " minutes")

