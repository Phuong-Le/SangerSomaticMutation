process cgpBigWig {
    publishDir "${params.outdir}/pindel_out/${meta.sample_id}"

    input:
    tuple val(meta), path(bam), path(bai)
    path fasta
    path fai
    val bamtobw_threads

    output:
    tuple val(meta), path("*.bw")

    script:
    """
    bamToBw.pl -p bamToBw -outdir . -reference ${fasta} -bam ${bam} -overlap -t ${bamtobw_threads}
    bamToBw.pl -p generateBw -outdir . -reference ${fasta} -bam ${bam} -overlap -index 1 -t 1
    """
}
