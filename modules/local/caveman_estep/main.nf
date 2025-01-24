process cavemanEstep {
    label 'caveman'
    label 'process_single'


    input:
    tuple val(meta), val(chrom), val(indices), val(splitlist_entry), path(readpos), path(splitlist), path(chrom_dir, stageAs: 'chrom_dir'), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed'), path(alg_bean), path(caveman_config), path(covs_arr), path(probs_arr)
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
    tuple val(meta), path(chrom)

    script:
    """
    rm -rf ${chrom}
    mkdir ${chrom}
    cp -R ${chrom_dir}/* ${chrom}
    for index in {${indices.min()}..${indices.max()}}
    do
    caveman estep --index \${index} --config-file ${caveman_config} --normal-contamination ${normal_contamination} --species ${species} --species-assembly ${species_assembly} --normal-protocol ${normal_protocol} --tumour-protocol ${tumour_protocol} --normal-copy-number ${normal_cn} --tumour-copy-number ${tumour_cn} --prior-mut-probability ${prior_mut_probability} --prior-snp-probability ${prior_snp_probability}
    done

    rm -f ${readpos} ${splitlist} ${chrom_dir} ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${alg_bean} ${caveman_config} ${covs_arr} ${probs_arr} ${fasta} ${filtered_fai} ${genome_gap}
    """
}
