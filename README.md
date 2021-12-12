# Purpose

1. a final project for a course on parallelization
2. [Proof of concept for OOP R packaging](https://github.com/cmatKhan/bartNP), and nextflow

# Installation

## Dependencies

For HTCF, you need the following:

1. [Nextflow: install using conda](https://bioconda.github.io/recipes/nextflow/README.html)
 - Install this into an environment that you'll remember, eg, maybe one called `nextflow`. 
 The command might look like `conda create -n nextflow nextflow`

## Running the pipeline on HTCF

2. Create a params file

```{json}
{
"gene_list": "data/gene_list_10.csv",
"nps": "data/kemmeren_np_fltr.rds",
"test_data": "data/test_tf_levels_full.rds",
"results": "results_10",
"x.test": "data/test_tf_levels_full.rds"
}
```

3. Clone this repository to whatever the working directory will be for running bart. For example, 
you can look at `/scratch/mblab/chasem/bartNP`

4. Copy the data from `/scratch/mblab/chasem/bartNP/data` into your working directory

5. update the ./bartNPNF/nextflow.config. You should make sure the paths are correct in the `params` 
section for `gene_list`, `nps`, `test_data`, `x.test`. `results` controls where the `results` directory 
is output to -- default is in the `${launchDir}`. The global variable `${launchDir}` is the directory 
from which you launch nextflow. If that isn't clear, please ask.

6. At this point, you have two options. you can either copy `/scratch/mblab/chasem/bartNP/run_nextflow.sh`. 
Open that script, read it, and make sure that all the paths, etc are correct for your environment. 
Launch the process with `sbatch run_nextflow.sh` (assuming you're in the same directory as the script).  

Alternatively, launch an interactive session and do the following:  

```
# load the cluster singularity
ml singularity

# do whatever it is you need to do to launch your conda environment with nextflow. FOR EXAMPLE
source activate /scratch/mblab/$USER/rnaseq_pipeline/conda_envs/nextflow

# set a variable pointing towards the config path in your bartNPNF directory (you need to update this)
config_path=/path/to/bartNPNF/nextflow.config

nextflow run nfNP/main.nf -c $config_path
```

I have run this, but I have not run through these installation instructions with anyone else. If you do this, you will 
be the first. As a result, if anything is unclear, let me know. If the paths are all correct, this will execute for you without 
any other setup.

## Running the pipeline on your local

This is simple, but I haven't written in the configuration. If you would like to try this out, 
you can look at the nextflow documentation and see if you can write the appropriate configuration 
in the `nextflow.config` script. Otherwise, I will do this at some point after Wednesday.
