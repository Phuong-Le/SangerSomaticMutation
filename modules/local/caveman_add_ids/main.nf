process cavemanAddIDS {
    label 'caveman'
    label 'process_tiny'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", mode: params.publish_dir_mode


    input:
    tuple val(meta), path(mutvcf), path(snpvcf), path(bedgz), path(bedgz_tbi)

    output:
    tuple val(meta), path(mutvcf_ided_gz), path(mutvcf_ided_gz_tbi), path(snpvcf_ided_gz), path(snpvcf_ided_gz_tbi)

    script:
    mutvcf_ided = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.muts.vcf"
    mutvcf_ided_gz = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.muts.vcf.gz"
    mutvcf_ided_gz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.muts.vcf.gz.tbi"
    snpvcf_ided = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.snps.vcf"
    snpvcf_ided_gz = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.snps.vcf.gz"
    snpvcf_ided_gz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.snps.vcf.gz.tbi"
    """
    cgpAppendIdsToVcf.pl -i ${mutvcf} -o "${mutvcf_ided}"
    bgzip ${mutvcf_ided}
    tabix -p vcf ${mutvcf_ided_gz}
    cgpAppendIdsToVcf.pl -i ${snpvcf} -o "${snpvcf_ided}"
    bgzip ${snpvcf_ided}
    tabix -p vcf ${snpvcf_ided_gz}

    rm -f ${mutvcf} ${snpvcf} ${bedgz} ${bedgz_tbi}
    """
}
