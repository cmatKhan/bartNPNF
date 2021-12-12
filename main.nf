/*
 * Copyright (c) 2021, Chase Mateusiak.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. 
 * 
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */


/* 
 * bartNPNF is a proof concept pipeline for nextflow
 * 
 * Chase Mateusiak
 */

/* 
 * Enable DSL 2 syntax
 */
nextflow.enable.dsl = 2

log.info """\
npNF  -  N F    v 2.1 
================================
gene_list : $params.gene_list
nps       : $params.nps
test_data : $params.test_data
ntree     : $params.ntree
results   : $params.results
ncpu_bart : "5"
"""

/* 
 * Import modules 
 */
include { 
  PER_GENE_BART } from './modules.nf' 

/* 
 * main pipeline logic
 */
workflow {

  Channel
    .fromPath(params.gene_list)
    .splitCsv(header:true, sep="\t")
    .map{ row-> row.gene }
    .set { genes_ch }

      // PART 1: BART modelling
      PER_GENE_BART(genes_ch)

}
