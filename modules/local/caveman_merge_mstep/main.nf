process cavemanMergeMstep {
    label 'caveman'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'covs_arr'
    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'probs_arr'

    input:
    tuple val(meta), path("mstep_out*"), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)

    output:
    tuple val(meta), path('covs_arr'), path('probs_arr'), path('mstep_out_all'), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)

    script:
    """
    mkdir mstep_out_all
    cp -R mstep_out*/* mstep_out_all
    ln -s mstep_out_all/* .
    caveman merge -f ${caveman_config}
    """
}
