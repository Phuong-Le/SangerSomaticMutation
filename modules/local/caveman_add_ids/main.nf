process cavemanAddIDS {
    label 'caveman'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}"


    input:
    tuple val(meta), path(mutvcf), path(snpvcf), path(bedgz), path(bedgz_tbi)

    output:
    tuple val(meta), path(mutvcf_ided_gz), path(mutvcf_ided_gz_tbi), path(snpvcf_ided_gz), path(snpvcf_ided_gz_tbi)

    script:
    mutvcf_ided = "${meta.sample_id}_vs_${meta.match_normal_id}.muts.vcf"
    mutvcf_ided_gz = "${meta.sample_id}_vs_${meta.match_normal_id}.muts.vcf.gz"
    mutvcf_ided_gz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.muts.vcf.gz.tbi"
    snpvcf_ided = "${meta.sample_id}_vs_${meta.match_normal_id}.snps.vcf"
    snpvcf_ided_gz = "${meta.sample_id}_vs_${meta.match_normal_id}.snps.vcf.gz"
    snpvcf_ided_gz_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.snps.vcf.gz.tbi"
    """
    cgpAppendIdsToVcf.pl -i ${mutvcf} -o "${mutvcf_ided}"
    bgzip ${mutvcf_ided}
    tabix -p vcf ${mutvcf_ided_gz}
    cgpAppendIdsToVcf.pl -i ${snpvcf} -o "${snpvcf_ided}"
    bgzip ${snpvcf_ided}
    tabix -p vcf ${snpvcf_ided_gz}
    """
}
