process cavemanMergeEstep {
    label 'caveman'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}"

    input:
    tuple val(meta), path("estep_out*"), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file), path(match_cn_file), path(alg_bean), path(caveman_config), path(readpos), path(splitlist)

    output:
    tuple val(meta), path(mutvcf), path(snpvcf), path(bedgz), path(bedgz_tbi)

    script:
    mutvcf = "${meta.sample_id}_vs_${meta.match_normal_id}.muts.raw.vcf"
    snpvcf = "${meta.sample_id}_vs_${meta.match_normal_id}.snps.raw.vcf"
    bedgz = "${meta.sample_id}_vs_${meta.match_normal_id}.no_analysis.bed.gz"
    bedgz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.no_analysis.bed.gz.tbi"
    """
    mkdir estep_out_all
    cp -R estep_out*/* estep_out_all
    mergeCavemanResults --splitList ${splitlist} -o ${mutvcf} -f estep_out_all/%/%.muts.vcf.gz
    mergeCavemanResults --splitList ${splitlist} -o ${snpvcf} -f estep_out_all/%/%.snps.vcf.gz
    mergeCavemanResults --splitList ${splitlist} -o ${meta.sample_id}_vs_${meta.match_normal_id}.no_analysis.bed -f estep_out_all/%/%.no_analysis.bed
    bgzip ${meta.sample_id}_vs_${meta.match_normal_id}.no_analysis.bed
    tabix -p bed ${bedgz}
    """
}
