/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { paramsSummaryMap       } from 'plugin/nf-schema'
include { CAVEMAN } from "${projectDir}/subworkflows/local/caveman"
include { PINDEL } from "${projectDir}/subworkflows/local/pindel"
include { CAVEMAN_FLAGGING } from "${projectDir}/subworkflows/local/caveman_flagging"
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow SANGERSOMATIC {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    ch_samplesheet_pindel
    fasta
    fai
    genome_gap
    caveman_ignore_contigs
    max_read_counts
    normal_contamination
    normal_cn
    tumour_cn
    species
    species_assembly
    normal_protocol
    tumour_protocol
    prior_mut_probability
    prior_snp_probability
    simrep
    simrep_tbi
    pindel_unmatch_panel
    pindel_unmatch_panel_tbi
    pindel_bad_loci
    pindel_bad_loci_tbi
    pindel_filter_rules
    pindel_soft_filter_rules
    genes
    genes_tbi
    sequencing_type
    pindel_exclude
    hidepth
    hidepth_tbi
    vagrent_dir
    caveman_flag_bed_dir
    caveman_flag_config
    caveman_flag_to_vcf_config
    caveman_unmatch_dir

    main:

    CAVEMAN(
        ch_samplesheet,
        fasta,
        fai,
        genome_gap,
        caveman_ignore_contigs,
        max_read_counts,
        normal_contamination,
        normal_cn,
        tumour_cn,
        species,
        species_assembly,
        normal_protocol,
        tumour_protocol,
        prior_mut_probability,
        prior_snp_probability
        )

    PINDEL(
        ch_samplesheet_pindel,
        fasta,
        fai,
        simrep,
        simrep_tbi,
        pindel_unmatch_panel,
        pindel_unmatch_panel_tbi,
        pindel_bad_loci,
        pindel_bad_loci_tbi,
        pindel_filter_rules,
        pindel_soft_filter_rules,
        genes,
        genes_tbi,
        species,
        species_assembly,
        sequencing_type,
        pindel_exclude,
        hidepth,
        hidepth_tbi,
        vagrent_dir
    )

    CAVEMAN_FLAGGING(
        ch_samplesheet_pindel
        .join(
            CAVEMAN.out
            .map{ meta, vcf, vcf_tbi, vcf_germline, vcf_germline_tbi -> tuple(meta, vcf, vcf_tbi) }
            )
        .join(PINDEL.out),
        fasta,
        fai,
        caveman_flag_bed_dir,
        vagrent_dir,
        caveman_flag_config,
        caveman_flag_to_vcf_config,
        caveman_unmatch_dir,
        species,
        sequencing_type
    )
    // CAVEMAN.out.view()
    // PINDEL.out.view()
    // emit:
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
