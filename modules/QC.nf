
process fastqc {
    tag "${fastq_files}"
    
    input:
        path fastq_files
    output:
        path ouput_dir
    
    script:
    def output_dir = "${fastq_files.simpleName}_qc"
    """
    mkdir $ouput_dir
    fastqc -t 4 -o $ouput_dir ${fastq_files}
    """
}

process multiqc {
    publishDir "${params.output_dir}/reports", mode: "copy"

    input:
        path logs

    output:
        path "multiqc_report.html"

    """
    multiqc .
    """
}