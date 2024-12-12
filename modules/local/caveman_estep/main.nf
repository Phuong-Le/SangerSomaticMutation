process cavemanEstep {
    label 'caveman'
    label 'process_single'

    input:
    tuple val(meta), val(index), val(splitlist_entry), path(readpos), path(splitlist), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed'), path(alg_bean), path(caveman_config), path(covs_arr), path(probs_arr), path(covs)
    path fasta
    path filtered_fai
    path genome_gap
    val normal_contamination
    val normal_cn
    val tumour_cn
    val species
    val species_assembly
    val normal_protocol
    val tumour_protocol
    val prior_mut_probability
    val prior_snp_probability

    output:
    tuple val(meta), path('estep_out')

    script:
    """
    rm -rf ${splitlist_entry.chrom} estep_out
    mkdir ${splitlist_entry.chrom}
    mv ${covs} ${splitlist_entry.chrom}
    caveman estep -i ${index} --config-file ${caveman_config} --normal-contamination ${normal_contamination} --species ${species} --species-assembly ${species_assembly} --normal-protocol ${normal_protocol} --tumour-protocol ${tumour_protocol} --normal-copy-number ${normal_cn} --tumour-copy-number ${tumour_cn} --prior-mut-probability ${prior_mut_probability} --prior-snp-probability ${prior_snp_probability}
    mkdir estep_out
    mv ${splitlist_entry.chrom} estep_out

    rm -f ${readpos} ${splitlist} ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${alg_bean} ${caveman_config} ${covs_arr} ${probs_arr} ${fasta} ${filtered_fai} ${genome_gap}
    """
}
