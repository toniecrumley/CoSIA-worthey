library(R6)

CoSIA_Instance <- R6Class("CoSIA_Instance",
  public = list(
    gene_symbol = "",
    input_species = "",
    comparing_species = c(),
    map_tissues = c(),
    metric_type = "",
    ortholog_database = "HomoloGene",
    cosia = NULL,
    conversion = NULL,
    expression_metrics = NULL,
    coefficient_variation_plot = NULL,
    initialize = function(gene_symbol = NA, input_species = NA, comparing_species = NA, map_tissues = NA, metric_type = NA) {
      self$gene_symbol <- gene_symbol
      self$input_species <- input_species
      self$comparing_species <- comparing_species
      self$map_tissues <- map_tissues
      self$metric_type <- metric_type
      self$greet()
    },
    greet = function() {
      cat(paste0("Hi, Going To Calculate the Coefficient of Variance for ", self$gene_symbol, " of tissues for species ", self$comparing_species))
    },
    configure = function() {
      self$cosia = CoSIA::CoSIAn(
        gene_set = self$gene_symbol,
        i_species = self$input_species,
        o_species = self$comparing_species,
        input_id = "Symbol",
        output_ids = "Ensembl_id",
        map_species = self$comparing_species,
        map_tissues = self$map_tissues,
        mapping_tool = "annotationDBI",
        ortholog_database = self$ortholog_database,
        metric_type = self$metric_type # Calculating it across tissue
      )
    },
    identifier_map = function() {
      tryCatch({
        self$conversion <- CoSIA::getConversion(self$cosia)
      }, warning = function(warningMessage) {
        no_target_list <- lapply(warningMessage, function(message) grepl("no target provided", message))
        if( length(no_target_list) > 0 ) {
          cat("HomoloGene database did not have a homolog for", self$gene_symbol)
          cat("Switching to the NCBIOrtho database to find homologous genes")
          self$ortholog_database = "NCBIOrtho"
          self$configure()
          self$conversion <- CoSIA::getConversion(self$cosia)
        }
      })
    },
    calculate_expression_metrics = function() {
      self$expression_metrics <- CoSIA::getGExMetrics(self$conversion)
    },
    calculate_coefficient_variation_plot = function() {
      self$coefficient_variation_plot <- CoSIA::plotCVGEx(self$expression_metrics)
    },
    calculate_diversity_and_specificity_plot = function() {
      self$diversity_and_specificity_plot <- CoSIA::plotDSGEx(self$expression_metrics)
    }
  )
)

#HumanRatCV_CoSIA <- CoSIA_Instance$new("VMA21", "h_sapiens", c("h_sapiens","r_norvegicus"), c("adult mammalian kidney","heart"), "CV_Tissue")

