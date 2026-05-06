# R Script Following Steps from vignette to plot the gene expression variability
# across species common tissue types of Human and each CPAM animal model type
# used

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
models_comparing <- c("m_musculus", "r_norvegicus", "d_rerio")
output_species <- c(models_comparing, input_species)

# From Vignette:
# NOTE: To compare across all shared tissues for your selected species,
# you can assign the getTissues output to an object as input for map_tissues
# when initializing a CoSIAn object.

for (animal_model in models_comparing) {
  cat("1. Getting tissues for species to compare with human - ", animal_model)
  map_tissues <- CoSIA::getTissues(c(input_species, animal_model))
  common_tissues <- map_tissues[["Common_Anatomical_Entity_Name"]]

  cat("2. Configuring CoSIA base library on data to process with human - ", animal_model)
  HumanAndAnimalModel_CoSIA <- CoSIA_Instance$new("VMA21", "h_sapiens", c(input_species, animal_model), common_tissues, "CV_Tissue")
  HumanAndAnimalModel_CoSIA$configure()

  cat("3. Converting the Input Gene set and getting identifier mappings")
  HumanAndAnimalModel_CoSIA$identifier_map()

  # metric_type = "CV_Tissue" # Calculating it across species
  cat("4. Calculating the expression metrics need for Coefficient Of Variation plot for", animal_model)
  HumanAndAnimalModel_CoSIA$calculate_expression_metrics()

  cat("4. Calculating the Coefficient of Variation across species for ", animal_model)
  HumanAndAnimalModel_CoSIA$calculate_coefficient_variation_plot()

  HumanAndAnimalModel_CoSIA$coefficient_variation_plot

  animal_end_time <- Sys.time()
  time.loop <- animal_end_time - beginning_time
  cat("Time elapsed For Model ",animal_model ,": ", round((time.loop),3), " minutes")
}

end_time <- Sys.time()

time.loop <- end_time - beginning_time
cat("Time elapsed: ", round((time.loop),3), " minutes")

