process cavemanMergeEstep {
    label 'caveman'
    label 'process_tiny'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", mode: params.publish_dir_mode

    input:
    tuple val(meta), path("estep_out*"), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)


    output:
    tuple val(meta), path(mutvcf), path(snpvcf), path(bedgz), path(bedgz_tbi)

    script:
    mutvcf = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.muts.no_ids.vcf"
    snpvcf = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.snps.no_ids.vcf"
    bedgz = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.no_analysis.bed.gz"
    bedgz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.no_analysis.bed.gz.tbi"
    """
    mkdir estep_all
    cp -R estep_out*/* estep_all
    mergeCavemanResults --splitList ${splitlist} -o ${mutvcf} -f estep_all/%/%.muts.vcf.gz
    mergeCavemanResults --splitList ${splitlist} -o ${snpvcf} -f estep_all/%/%.snps.vcf.gz
    mergeCavemanResults --splitList ${splitlist} -o ${meta.sample_id}_vs_${meta.match_normal_id}.caveman.no_analysis.bed -f estep_all/%/%.no_analysis.bed
    bgzip ${meta.sample_id}_vs_${meta.match_normal_id}.caveman.no_analysis.bed
    tabix -p bed ${bedgz}

    rm -rf estep_out*
    rm -rf estep_all
    rm -f ${alg_bean} ${caveman_config} ${readpos} ${splitlist}
    """
}
