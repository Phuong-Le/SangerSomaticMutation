process cavemanSplit {
    label 'caveman'
    label 'process_small'

    input:
    tuple val(index), val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed'), path(alg_bean), path(caveman_config)
    val(read_count)
    path fasta
    path filtered_fai
    path genome_gap

    output:
    tuple val(index), val(meta), path('readpos*'), path('splitList*')


    script:
    """
    caveman split --config-file ${caveman_config} --index ${index} --read-count ${read_count}
    rm -f ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${alg_bean} ${caveman_config} ${fasta} ${filtered_fai} ${genome_gap}
    """
}
