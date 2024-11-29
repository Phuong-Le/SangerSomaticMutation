process cavemanMstep {
    label 'caveman'

    input:
    tuple val(index), val(splitlist_entry), val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)
    path fasta
    path filtered_fai
    path genome_gap

    output:
    tuple val(meta), path("mstep_out")

    script:
    """
    caveman mstep --index ${index} --config-file ${caveman_config}
    mkdir mstep_out
    mv ${splitlist_entry} mstep_out
    """
}
