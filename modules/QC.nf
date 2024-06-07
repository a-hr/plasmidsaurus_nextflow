
process fastqc {
    tag "${fastq_files.simpleName}"
    
    input:
        path fastq_files
    output:
        path "${fastq_files.simpleName}_qc"
    
    script:
    """
    mkdir "${fastq_files.simpleName}_qc"
    fastqc -t ${task.cpus} -o "${fastq_files.simpleName}_qc" ${fastq_files}
    """
}

process multiqc {
    publishDir "${params.output_dir}/reports", mode: "copy"
    containerOptions "${workflow.containerEngine == "docker" ? '--user $(id -u):$(id -g) --group-add 100' : ''}"

    input:
        path fq_pre
        path fq_post
        path porechop

    output:
        path "multiqc_${params.run_name}.html"

    """
    multiqc . -n multiqc_${params.run_name}.html
    """
}