process vafAugment {
    publishDir "${params.outdir}/pindel_out/${meta.sample_id}", pattern: 'vaf_out/*.flagged.vaf.vcf.gz*'

    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(vcf), path(vcf_tbi)
    path fasta
    path fai
    path hidepth
    path hidepth_tbi
    val vafaugment_exonerate_mb

    output:
    tuple val(meta), path(vcf_gz_out), path(vcf_tbi_out)

    script:
    vcf_gz_out = "vaf_out/${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vaf.vcf.gz"
    vcf_tbi_out = "vaf_out/${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vaf.vcf.gz.tbi"
    """
    cgpVaf.pl --augment -restrict_flag 1 --high_depth_bed ${hidepth} --vcf ${vcf} --output_vcfExtension .vaf.vcf --inputDir . --outDir ./vaf_out --variant_type indel --genome ${fasta} --tumour_name ${meta.sample_id} --normal_name ${meta.match_normal_id} --tumour_bam ${bam} --normal_bam ${bam_match} --exonerate_mb ${vafaugment_exonerate_mb}
    """

}
