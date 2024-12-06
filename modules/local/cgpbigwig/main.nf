process cgpBigWig {
    label 'process_single'

    publishDir "${params.outdir}/pindel_out/${meta.sample_id}", mode: params.publish_dir_mode

    input:
    tuple val(meta), path(bam), path(bai)
    path fasta
    path fai

    output:
    tuple val(meta), path("*.bw")

    script:
    """
    bamToBw.pl -p bamToBw -outdir . -reference ${fasta} -bam ${bam} -overlap -t ${task.cpus}
    bamToBw.pl -p generateBw -outdir . -reference ${fasta} -bam ${bam} -overlap -index 1 -t 1

    rm -f ${bam} ${bai} ${fasta} ${fai}
    """
}
