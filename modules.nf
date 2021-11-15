/*
 * Process 1: Run BART on each gene
 */

process PER_GENE_BART {

  label 'bart'
  
  publishDir "$params.results" 

  input:
    val gene
    path nps
    val ntree
    path test_data
  output:
    file "*_bart_out.rds"

  script:
  """
    #!/usr/bin/Rscript

    library(bartNP)
    
    nps = readRDS("${nps}")

    predictors = regPredictors(nps, "${gene}")
    
    response_array = as.vector(exprMat(nps["${gene}",]))

    test_data = readRDS("${test_data}")
    
    n_tree = as.numeric(${ntree})

    output_filename = paste0("${gene}", "_bart_out.rds")
    
    # note: this is wrapped in a function in bartNP, but 
    #       it only calls mc.wbart()
    bart_out = bartForOneGene(predictors, 
                              response_array, 
                              test_data,
                              ntree = n_tree, 
                              mc.cores = as.numeric(${task.cpus}))

    saveRDS(bart_out, file = output_filename)
  """
}


