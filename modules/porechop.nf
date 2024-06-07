
process porechop {
    tag "$fastq.simpleName"
    input:
        path fastq
    
    output:
        path "${fastq.simpleName}_trim.fastq.gz", emit: fastq
        path "porechop_${fastq.simpleName}.log", emit: logs

    script:
        """
        eval "\$(micromamba shell hook --shell=bash)"
        
        # Run the script
        porechop_abi -abi -i $fastq -o chopped.fastq.gz > porechop_${fastq.simpleName}.log

        # trim T's at the beginning of the reads
        cutadapt -j 0 -g ^T{30} -e 0.2 --poly-a -m ${params.min_len} -M ${params.max_len} -o ${fastq.simpleName}_trim.fastq.gz chopped.fastq.gz
        """
}