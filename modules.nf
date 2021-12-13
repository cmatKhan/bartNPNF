/*
 * Process 1: Run BART on each gene
 */

process PER_GENE_BART {

  label 'bart'
  
  publishDir "$params.results" 

  input:
    val gene
    path nps
  output:
    file "*_bart_out.rds"

  script:
  """
    #!/usr/bin/Rscript

    library(bartNP)
    
    nps = readRDS("${nps}")

    predictors = regPredictors(nps, "${gene}")

    test_data = readRDS("${params.test_data}")
    
    n_tree = as.numeric(${params.ntree})

    response_array = as.vector(exprMat(nps["${gene}",]))

    output_filename = paste0("${gene}", "_bart_out.rds")

    bart_out = bartForOneGene(predictors, 
                              response_array, 
                              test_data,
                              ntree = n_tree, 
                              mc.cores = as.numeric(${task.cpus}))

    saveRDS(bart_out, file = output_filename)
    
  """
}


