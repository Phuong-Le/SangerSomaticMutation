process cavemanFlagging {
    label 'caveman'

    publishDir "${params.outdir}/caveman_flagging_out/${meta.sample_id}", mode: params.publish_dir_mode

    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(vcf), path(vcf_tbi), path(pindel_germline_bed), path(pindel_germline_bed_tbi)
    path fasta
    path fai
    path caveman_flag_bed_dir
    path vagrent_dir
    path caveman_flag_config
    path caveman_flag_to_vcf_config
    path caveman_unmatch_dir
    val species
    val sequencing_type

    output:
    tuple val(meta), path(vcf_gz_out), path(vcf_tbi_out)

    script:
    vcf_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.flagged.muts.vcf"
    vcf_gz_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.flagged.muts.vcf.gz"
    vcf_tbi_out = "${meta.sample_id}_vs_${meta.match_normal_id}.caveman.flagged.muts.vcf.gz.tbi"
    """
    cgpFlagCaVEMan.pl --input ${vcf} --outFile ${vcf_out} --species ${species} --reference ${fai} --studyType ${sequencing_type} --tumBam ${bam} --normBam ${bam_match} --bedFileLoc ${caveman_flag_bed_dir} --annoBedLoc ${vagrent_dir} --flagConfig ${caveman_flag_config} --flagToVcfConfig ${caveman_flag_to_vcf_config} --indelBed ${pindel_germline_bed} --unmatchedVCFLoc ${caveman_unmatch_dir}
    bgzip ${vcf_out}
    tabix -p vcf ${vcf_gz_out}

    rm -f ${bam} ${bai} ${bam_match} ${bai_match} ${vcf} ${vcf_tbi} ${pindel_germline_bed} ${pindel_germline_bed_tbi} ${fasta} ${fai} ${caveman_flag_config} ${caveman_flag_to_vcf_config}
    rm -rf ${caveman_flag_bed_dir} ${vagrent_dir} ${caveman_unmatch_dir}
    """
}
