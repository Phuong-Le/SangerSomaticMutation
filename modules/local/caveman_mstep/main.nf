process cavemanMstep {
    label 'caveman'
    label 'process_single'

    input:
    tuple val(meta), val(chrom), val(indices), val(splitlist_entry), path(readpos), path(splitlist), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed'), path(alg_bean), path(caveman_config)
    path fasta
    path filtered_fai
    path genome_gap

    output:
    tuple val(meta), val(chrom), path(chrom)

    script:
    """
    rm -rf ${chrom}
    for index in {${indices.min()}..${indices.max()}}
    do
    caveman mstep --index \${index} --config-file ${caveman_config}
    done

    rm -f ${readpos} ${splitlist} ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${alg_bean} ${caveman_config} ${fasta} ${filtered_fai} ${genome_gap}
    """
}
