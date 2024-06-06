# a-hr/ONT-splicing-pipeline pipeline parameters


## Introduction

A pipeline to process the sequencing output coming from Plasmidsaurus. It can also be used with standard Nanopore data, but keep in mind that each sample must be provided as a single FASTQ file.

The pipeline performs the following steps:

1. QC of the FASTQ files
2. Alignment of the reads to the reference genome
3. Generation of BAM files
4. Generation of sashimi-plots using ggsashimi

## Installation

The pipeline is written in Nextflow, a workflow manager that allows to run the pipeline in a wide variety of systems. It is configured to be run either on a SLURM-managed HPC cluster or a local machine, though it can be run on a cloud instance or using other workload managers by editing the configuration file according to [Nextflow documentation](https://www.nextflow.io/docs/latest/config.html#config-scopes).


### Installing in a local machine

In your local machine, there are two ways of running the pipeline:

1. Using EPI2ME: the easiest way for those without bioinformatics experience. It's just a graphical interface that allows you to run the pipeline. Below will be explained how to install it.
2. Using the command line: for those with bioinformatics experience. It follows the same procedure as running in a cluster, so it will be explained in the `Installing in a cluster` section.

#### Installing EPI2ME

[Install EPI2ME](https://labs.epi2me.io/installation/) on your system and follow the instructions on the app to install all the dependencies (Java, Docker and Nextflow). To add the pipeline to your saved workflows simply copy this repository's URL and paste it on the "Add workflow" section of the EPI2ME interface.

### Installing in a cluster

If using Nextflow/nf-core, clone the repository and install the basic dependencies (Nextflow). The easiest way to do so is using conda. The pipeline can be run on any system that supports Docker or Singularity. If using Windows, we recommend using the Windows Subsystem for Linux (WSL).

```bash
git clone https://github.com/a-hr/plasmidsaurus_nextflow.git
```

The internal dependencies of the pipeline are managed by Nextflow, so you don't need to worry about them. If for some reason Nextflow fails to download them when using Singularity (they are provided as Docker containers), you can manually download them with the Makefile:

```bash
# make sure you have Singularity installed and available
make pull
```

The pipeline is especially tailored to be run on a HPC cluster, though it can seamlessly be run on a local machine and, with some configuration, on a cloud instance.

## Usage

### Running with EPI2ME

1. Open EPI2ME and go to the "Workflows" tab.
2. Select the workflow.
3. Fill in the parameters.
4. In the `profile` section, type in `local_docker`.
5. Run the pipeline.

### Running with the command line

1. Go to the directory where you cloned the repository.
2. Fill in the parameters in the `input_params.yaml` file.
3. Make sure your system has Docker/Singularity and Nextflow available.
4. Run the pipeline in the cluster with the following command:

```bash
sbatch launch.sh
```

> The launch script is configured to run the pipeline in a SLURM-managed HPC cluster. If you are using another workload manager, you will need to edit the script accordingly.  

***If you are running the pipeline in a local machine, you can run it with the following command:***

```bash
nextflow run main.nf -profile local_docker -params-file input_params.yaml
# or with Singularity
nextflow run main.nf -profile local_singularity -params-file input_params.yaml
```

## Parameters

### Run options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `run_name` | name of the experiment (files will be named after it) | `string` | plasmidsaurus-mar24 |  |  |
| `output_dir` |  | `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/output-plasmidsaurus-mar24 |  | True |
| `get_bams` | whether to output the aligned BAMs | `boolean` | True |  |  |
| `get_sashimis` | whether to generate sashimi plots | `boolean` | True |  |  |

### Input parameters



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `input_fastq` | path to the directory containing the FASTQ files to align | `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/inputs/fastqs | True |  |
| `ref_fa` | path to the reference FASTA | `string` | /scratch/heral/indexes/GRCh38.primary_assembly.genome.fa | True |  |
| `ref_bed` | path to the reference BED file to allow splice-aware alignment | `string` | /scratch/heral/indexes/gencode.v41.primary_assembly.annotation.bed | True |  |
| `ref_gtf` | path to the reference GTF file to include transcript annotations in sashimis | `string` | /scratch/heral/indexes/gencode.v41.primary_assembly.annotation.gtf |  |  |
| `plots_config` | path to the CSV file containing plot configuration. <details><summary>Help</summary><small>The semicolon (;) separated file should have the following fields:<br>- plotID <int>: the ID that groups twogether the BAMs of the plot. Can be repeated as many times as necessary.<br>- coords <str>: the coordinates that will be used in the plot. Format: chr:start-end  <br>- fastqName: the name, without extension, of the file to include in the plot. Can be used in more than one plot.<br>- groupName: the group the file belongs to (e.g WT, KO...). Groups together different files inside a specific plot.</small></details>| `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/inputs/plots.csv | True |  |

### QC options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `min_len` | minimum length a read should have in order to be processed | `integer` | 200 |  |  |
| `max_len` | maximum length a read should have in order to be processed | `integer` | 5000 |  |  |

### Plot options

ggsashimi's internal options

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `sashimi_min_cov` | minimum coverage of an event in order to be included | `integer` | 5 |  |  |
| `sashimi_alpha` | alpha to apply on the coverage colour | `number` | 0.6 |  |  |
| `sashimi_collapse_groups` | collapse the files by group | `boolean` |  |  |  |
| `sashimi_shrink` | shrink the intronic regions without coverage | `boolean` |  |  |  |
| `sashimi_fix_scale` | set the same Y-axis scale to all the groups/files | `boolean` | True |  |  |
| `sashimi_annot_height` | height of the annotations in the transcript track | `integer` | 5 |  |  |
| `sashimi_width` | width in cm of the output plot | `integer` | 15 |  |  |
