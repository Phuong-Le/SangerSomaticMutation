process cavemanEstep {
    label 'caveman'

    input:
    tuple val(index), val(splitlist_entry), val(meta), path('covs_arr'), path('probs_arr'), path('mstep_out_all'), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)
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
    mkdir ${splitlist_entry}
    ln -s mstep_out_all/${splitlist_entry}/* ${splitlist_entry}
    caveman estep -i ${index} --config-file ${caveman_config} --normal-contamination ${normal_contamination} --species ${species} --species-assembly ${species_assembly} --normal-protocol ${normal_protocol} --tumour-protocol ${tumour_protocol} --normal-copy-number ${normal_cn} --tumour-copy-number ${tumour_cn} --prior-mut-probability ${prior_mut_probability} --prior-snp-probability ${prior_snp_probability}
    mkdir estep_out
    mv ${splitlist_entry} estep_out
    """
}
