process cavemanSplit {
    label 'caveman'

    input:
    tuple val(index), val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config)
    val(read_count)
    path fasta
    path filtered_fai
    path genome_gap

    output:
    tuple val(index), val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path('readpos*'), path('splitList*')


    script:
    """
    caveman split --config-file ${caveman_config} --index ${index} --read-count ${read_count}
    """
}
