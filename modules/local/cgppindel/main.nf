process cgpPindel {
    publishDir "${params.outdir}/pindel_out/${meta.sample_id}", pattern: 'logs'
    publishDir "${params.outdir}/pindel_out/${meta.sample_id}", pattern: '*.germline.bed.*'

    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match)
    path fasta
    path fai
    path simrep
    path simrep_tbi
    path pindel_unmatch_panel
    path pindel_unmatch_panel_tbi
    path pindel_bad_loci
    path pindel_bad_loci_tbi
    path pindel_filter_rules
    path pindel_soft_filter_rules
    path genes
    path genes_tbi
    val species
    val species_assembly
    val sequencing_type
    val pindel_ncpus
    path pindel_exclude

    output:
    tuple val(meta), path(mt_bam), path(mt_bai), path(wt_bam), path(wt_bai), emit: bams
    tuple val(meta), path(vcf), path(vcf_tbi), emit: vcfs
    tuple val(meta), path(germline_bed_gz), path(germline_bed_tbi), emit: germline_beds
    path 'logs'

    script:
    mt_bam = "${meta.sample_id}_vs_${meta.match_normal_id}_mt.bam"
    mt_bai = "${meta.sample_id}_vs_${meta.match_normal_id}_mt.bam.bai"
    wt_bam = "${meta.sample_id}_vs_${meta.match_normal_id}_wt.bam"
    wt_bai = "${meta.sample_id}_vs_${meta.match_normal_id}_wt.bam.bai"
    vcf = "${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vcf.gz"
    vcf_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.flagged.vcf.gz.tbi"
    germline_bed = "${meta.sample_id}_vs_${meta.match_normal_id}.germline.bed"
    germline_bed_gz = "${meta.sample_id}_vs_${meta.match_normal_id}.germline.bed.gz"
    germline_bed_tbi = "${meta.sample_id}_vs_${meta.match_normal_id}.germline.bed.gz.tbi"
    """
    pindel.pl -outdir . -tumour $bam -normal $bam_match -reference $fasta -simrep $simrep -unmatched $pindel_unmatch_panel -badloci $pindel_bad_loci -filter $pindel_filter_rules -softfil $pindel_soft_filter_rules -genes $genes -species $species -assembly $species_assembly -seqtype $sequencing_type -cpus $pindel_ncpus -exclude $pindel_exclude
    bgzip ${germline_bed}
    tabix -p bed ${germline_bed_gz}
    """
}
