process cavemanMstep {
    label 'caveman'
    label 'process_single'

    input:
    tuple val(meta), val(index), val(splitlist_entry), path(readpos), path(splitlist), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed'), path(alg_bean), path(caveman_config)
    path fasta
    path filtered_fai
    path genome_gap

    output:
    tuple val(meta), path("mstep_out")

    script:
    """
    rm -rf mstep_out
    mkdir mstep_out
    caveman mstep --index ${index} --config-file ${caveman_config}
    mv ${splitlist_entry.chrom} mstep_out
    rm -f ${readpos} ${splitlist} ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${fasta} ${filtered_fai} ${genome_gap}
    """
}
