process cavemanVagrent {
    label 'vagrent'
    label 'process_low'

    publishDir "${params.outdir}/caveman_flagging_out/${meta.sample_id}", mode: params.publish_dir_mode

    input:
    tuple val(meta), path(vcf), path(vcf_tbi)
    path vagrent_dir

    output:
    tuple val(meta), path(vcf_gz_out), path(vcf_tbi_out)

    script:
    vcf_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.annot.flagged.muts.vcf"
    vcf_gz_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.annot.flagged.muts.vcf.gz"
    vcf_tbi_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.annot.flagged.muts.vcf.gz.tbi"
    """
    AnnotateVcf.pl -i ${vcf} -o ${vcf_out} --cache ${vagrent_dir}/vagrent.cache.gz --tabix

    rm -f ${vcf} ${vcf_tbi}
    rm -rf ${vagrent_dir}
    """



}
