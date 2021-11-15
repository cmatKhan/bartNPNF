
/*
 * Process 1: Extract gene models from NetProphetDataSet
 */

process SPLIT_NPS { 
  
  input: 
    val gene
    path nps
 
  output: 
        tuple path("*_pred.rds"), path("*_res.rds"), val(gene)
  
  script:
  """
    #!/usr/bin/Rscript

    library(bartNP)

    nps = readRDS("${nps}")

    predictors_output_name = paste0("${gene}", "_pred.rds")
    response_output_name = paste0("${gene}", "_res.rds")

    regulator_pred_matrix = regPredictors(nps, "${gene}")
      
    response_nps = nps["${gene}",]

    saveRDS(regulator_pred_matrix, file = predictors_output_name)
    saveRDS(response_nps, file = response_output_name)

  """
}


/*
 * Process 2: Run BART on each model
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

    bart_out = bartForOneGene(predictors, 
                              response_array, 
                              test_data,
                              ntree = n_tree, 
                              mc.cores = as.numeric(${task.cpus}))

    saveRDS(bart_out, file = output_filename)
  """
}


