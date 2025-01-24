process cavemanMergeMstep {
    label 'caveman'
    label 'process_single'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'covs_arr', mode: params.publish_dir_mode
    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'probs_arr', mode: params.publish_dir_mode

    input:
    tuple val(meta), val(chrom), path(chrom_dir), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)

    output:
    tuple val(meta), path('covs_arr'), path('probs_arr')

    script:
    """
    caveman merge -f ${caveman_config}
    rm -f ${alg_bean} ${caveman_config} ${readpos} ${splitlist}
    rm -rf ${chrom_dir}
    """
}
