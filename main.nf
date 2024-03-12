#!/usr/bin/env Nextflow
nextflow.enable.dsl=2

include { fastqc; multiqc } from './modules/QC'
include { align } from './modules/alignment'
include { processCSV; sashimi} from './modules/create_plots'

// ---- Input files ----
sashimi_palette = Channel.value(projectDir + "/assets/palette.txt")

fa = Channel.value(params.ref_fa)
gtf = Channel.value(params.ref_gtf)
bed = Channel.value(params.ref_bed)

plots_csv = Channel.fromPath(params.plots_config)

input_fastqs = Channel.fromPath("$params.input_fastq/*.fastq*", checkIfExists: true)

// ---- Run the pipeline ----
workflow {
    // ---- Quality control ----
    fastqc(input_fastqs)
    multiqc(fastqc.out.collect())

    // ---- Alignment ----
    align(fa, bed, input_fastqs)

    // ---- Create plots ----
    align.out | collect \
    | set { all_bams }
    
    processCSV(plots_csv) | flatten \
    | set { bam_tsvs }

    sashimi(all_bams, gtf, sashimi_palette, bam_tsvs)
}