# Purpose

1. a final project for a course on parallelization
2. [Proof of concept for OOP R packaging](https://github.com/cmatKhan/bartNP), and nextflow

# Installation

Simply `git clone https://github.com/cmatKhan/bartNFNP` to the system on which you wish to run 
this pipeline.

## Dependencies

For HTCF, you need the following:

1. [Nextflow: install using conda](https://bioconda.github.io/recipes/nextflow/README.html)
 - Install this into an environment that you'll remember, eg, maybe one called `nextflow`. 
 The command might look like `conda create -n nextflow nextflow`

## Running the pipeline on HTCF

3. See the vignette in [bartNP](https://cmatkhan.github.io/bartNP/articles/holstege_deleteome_nps.html) 
to construct the data object.

4. Save the data on the system on which you wish to run the pipeline.

`gene_list.csv` is a single column csv with header `gene` of the gene names in the data
`kemmeren_np_fltr.rds` is the data object constructed in 3.

```{json}
{
"gene_list": "data/gene_list.csv",
"nps": "data/kemmeren_np_fltr.rds",
"results": "results"
}
```

5. Run nextflow. You can either run this on an interactive node, or use a script akin to the one below.

```{bash}
#!/bin/bash

#SBATCH --time=2-25:00:00  # right now, 15 hours. change depending on time expectation to run
#SBATCH --mem-per-cpu=10G
#SBATCH -J nf_test.out
#SBATCH -o nf_test.out

ml singularity
ml miniconda

source activate /scratch/mblab/chasem/rnaseq_pipeline/conda_envs/nextflow

mkdir tmp

num=10

params=params_${num}.json

nextflow run bartNPNF/main.nf -params-file $params -resume

```