# a-hr/ONT-splicing-pipeline pipeline parameters

A pipeline to QC, align and sashimi-plot ONT sequencing data.

## Run options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `run_name` | name of the experiment (files will be named after it) | `string` | plasmidsaurus-mar24 |  |  |
| `output_dir` |  | `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/output-plasmidsaurus-mar24 |  | True |
| `get_bams` | whether to output the aligned BAMs | `boolean` | True |  |  |

## Input parameters



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `input_fastq` | path to the directory containing the FASTQ files to align | `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/inputs/fastqs | True |  |
| `ref_fa` | path to the reference FASTA | `string` | /scratch/heral/indexes/GRCh38.primary_assembly.genome.fa | True |  |
| `ref_bed` | path to the reference BED file to allow splice-aware alignment | `string` | /scratch/heral/indexes/gencode.v41.primary_assembly.annotation.bed | True |  |
| `ref_gtf` | path to the reference GTF file to include transcript annotations in sashimis | `string` | /scratch/heral/indexes/gencode.v41.primary_assembly.annotation.gtf |  |  |
| `plots_config` | path to the CSV file containing plot configuration. <details><summary>Help</summary><small>The semicolon (;) separated file should have the following fields:<br>- plotID <int>: the ID that groups twogether the BAMs of the plot. Can be repeated as many times as necessary.<br>- coords <str>: the coordinates that will be used in the plot. Format: chr:start-end  <br>- fastqName: the name, without extension, of the file to include in the plot. Can be used in more than one plot.<br>- groupName: the group the file belongs to (e.g WT, KO...). Groups together different files inside a specific plot.</small></details>| `string` | /Users/varo/Desktop/pipe_plasmidsaurus/plasmidsaurus_pipeline/inputs/plots.csv | True |  |

## QC options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `min_len` | minimum length a read should have in order to be processed | `integer` | 200 |  |  |
| `max_len` | maximum length a read should have in order to be processed | `integer` | 5000 |  |  |

## Plot options

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
