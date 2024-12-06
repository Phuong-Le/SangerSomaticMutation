process vafAugment {
    label 'process_low'

    publishDir "${params.outdir}/pindel_out/${meta.sample_id}", pattern: "*.flagged.vafaugment.vcf.gz*", mode: params.publish_dir_mode

    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(vcf), path(vcf_tbi)
    path fasta
    path fai
    path hidepth
    path hidepth_tbi

    output:
    tuple val(meta), path(vcf_gz_out), path(vcf_tbi_out)

    script:
    vcf_gz_out = "vaf_out/${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vafaugment.vcf.gz"
    vcf_tbi_out = "vaf_out/${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vafaugment.vcf.gz.tbi"
    """
    cgpVaf.pl --augment -restrict_flag 1 --high_depth_bed ${hidepth} --vcf ${vcf} --output_vcfExtension .vafaugment.vcf --inputDir . --outDir ./vaf_out --variant_type indel --genome ${fasta} --tumour_name ${meta.sample_id} --normal_name ${meta.match_normal_id} --tumour_bam ${bam} --normal_bam ${bam_match} --exonerate_mb ${task.memory}

    rm -f ${bam} ${bai} ${bam_match} ${bai_match} ${vcf} ${vcf_tbi} ${fasta} ${fai} ${hidepth} ${hidepth_tbi}
    rm -f vaf_out/*_indel_vaf.* vaf_out/${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vafaugment.vcf
    """

}
