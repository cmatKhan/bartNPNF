/*
 * Process 1: Run BART on each gene
 */

process PER_GENE_BART {

  label 'bart'
  
  publishDir "$params.results" 

  input:
    val gene_list
    path nps
  output:
    file "*_bart_out.rds"

  script:
  """
    #!/usr/bin/Rscript

    library(bartNP)
    
    nps = readRDS("${params.nps}")

    gene_list = strsplit(${gene_list}, ",")[[1]]

    test_data = readRDS("${params.test_data}")
        
    n_tree = as.numeric(${params.ntree})

    for(gene in gene_list){

      cl = parallel::makePSOCKcluster(as.numeric(${task.cpus}))

        predictors = regPredictors(nps, as.character(gene))
    
        response_array = as.vector(exprMat(nps[gene,]))

        output_filename = paste0(gene, "_bart_out.rds")
        
        # note: this is wrapped in a function in bartNP, but 
        #       it only calls mc.wbart()
        bart_out = bartForOneGene(predictors, 
                                  response_array, 
                                  test_data,
                                  ntree = n_tree, 
                                  mc.cores = as.numeric(${task.cpus}))

        stopCluster(cl)
        saveRDS(bart_out, file = output_filename)
    }
  """
}


