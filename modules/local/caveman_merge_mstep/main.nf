process cavemanMergeMstep {
    label 'caveman'
    label 'process_single'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'covs_arr', mode: params.publish_dir_mode
    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'probs_arr', mode: params.publish_dir_mode

    input:
    tuple val(meta), path("mstep_out*"), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)

    output:
    tuple val(meta), path('covs_arr'), path('probs_arr'), path('mstep_all')

    script:
    """
    rm -rf mstep_all
    mkdir mstep_all
    cp -R mstep_out*/* mstep_all
    ln -sf mstep_all/* .
    caveman merge -f ${caveman_config}

    caveman_merge_mstep_cleanup.sh
    rm -f ${alg_bean} ${caveman_config} ${readpos} ${splitlist}
    """
}
