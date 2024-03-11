
process align {
    tag "${fastq}"
    
    publishDir "${params.output_dir}/bams",
        enabled: params.get_bams,
        mode: 'copy'

    input:
        path reference
        path bed
        path fastq

    output:
        path "*.bam*", emit: bams

    script:
    def outName = fastq.simpleName
    """
    minimap2 -t ${task.cpus} -ax splice --junc-bed ${bed} -c --MD ${reference} ${fastq} \\
        | samtools view -b - \\
        | samtools sort -o ${outName}.bam

    samtools index ${outName}.bam
    """
}
