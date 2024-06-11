#!/usr/bin/env Nextflow
nextflow.enable.dsl=2

include { fastqc as fastqc_pre; fastqc as fastqc_post; multiqc } from './modules/QC'
include { porechop } from './modules/porechop'
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
    fastqc_pre(input_fastqs)
    fastq_pre_out = fastqc_pre.out.collect()
    
    if (params.run_porechop) {
        input_fastqs | flatten \
        | porechop

        fastqc_post(porechop.out.fastq)

        fastqc_post_out = fastqc_post.out.collect()
        porechop_logs   = porechop.out.logs.collect()
        to_align        = porechop.out.fastq
    } else {
        fastqc_post_out = channel.empty()
        porechop_logs   = channel.empty()
        to_align        = input_fastqs | flatten
    }

    // ---- Alignment ----
    align(fa, bed, to_align)

    // ---- Create plots ----
    align.out | collect \
    | set { all_bams }
    
    processCSV(plots_csv) | flatten \
    | set { bam_tsvs }

    sashimi(all_bams, gtf, sashimi_palette, bam_tsvs)

    // ---- Collect reports ----
    multiqc(
        fastq_pre_out,
        fastqc_post_out,
        porechop_logs
    )
}