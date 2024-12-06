#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/sangersomatic
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/nf-core/sangersomatic
    Website: https://nf-co.re/sangersomatic
    Slack  : https://nfcore.slack.com/channels/sangersomatic
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { SANGERSOMATIC  } from './workflows/sangersomatic'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_sangersomatic_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_sangersomatic_pipeline'
include { getGenomeAttribute      } from './subworkflows/local/utils_nfcore_sangersomatic_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// // fetch reference genome parameters if not specified separately through command line
params.fasta = getGenomeAttribute('fasta')
params.fai = getGenomeAttribute('fai')
params.hidepth = getGenomeAttribute('hidepth')
params.hidepth_tbi = getGenomeAttribute('hidepth_tbi')
params.genome_gap = getGenomeAttribute('genome_gap')
params.caveman_ignore_contigs = getGenomeAttribute('caveman_ignore_contigs')
params.simrep = getGenomeAttribute('simrep')
params.simrep_tbi = getGenomeAttribute('simrep_tbi')
params.pindel_unmatch_panel = getGenomeAttribute('pindel_unmatch_panel')
params.pindel_unmatch_panel_tbi = getGenomeAttribute('pindel_unmatch_panel_tbi')
params.pindel_bad_loci = getGenomeAttribute('pindel_bad_loci')
params.pindel_bad_loci_tbi = getGenomeAttribute('pindel_bad_loci_tbi')
params.pindel_filter_rules = getGenomeAttribute('pindel_filter_rules')
params.pindel_soft_filter_rules = getGenomeAttribute('pindel_soft_filter_rules')
params.genes = getGenomeAttribute('genes')
params.genes_tbi = getGenomeAttribute('genes_tbi')
params.pindel_exclude = getGenomeAttribute('pindel_exclude')
params.vagrent_dir = getGenomeAttribute('vagrent_dir')
params.caveman_flag_bed_dir = getGenomeAttribute('caveman_flag_bed_dir')
params.caveman_flag_config = getGenomeAttribute('caveman_flag_config')
params.caveman_flag_to_vcf_config = getGenomeAttribute('caveman_flag_to_vcf_config')
params.caveman_unmatch_dir = getGenomeAttribute('caveman_unmatch_dir')
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline depending on type of input
//
workflow NFCORE_SANGERSOMATIC {
    take:
    samplesheet // channel: samplesheet read in from --input
    samplesheet_pindel
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

    //
    // WORKFLOW: Run pipeline
    //
    SANGERSOMATIC (
        samplesheet,
        samplesheet_pindel,
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
        prior_snp_probability,
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
        sequencing_type,
        pindel_exclude,
        hidepth,
        hidepth_tbi,
        vagrent_dir,
        caveman_flag_bed_dir,
        caveman_flag_config,
        caveman_flag_to_vcf_config,
        caveman_unmatch_dir
    )

}
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:
    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        args,
        params.outdir,
        params.input
    )

    //
    // WORKFLOW: Run main workflow
    //
    NFCORE_SANGERSOMATIC (
        PIPELINE_INITIALISATION.out.samplesheet,
        PIPELINE_INITIALISATION.out.samplesheet_pindel,
        params.fasta,
        params.fai,
        params.genome_gap,
        params.caveman_ignore_contigs,
        params.max_read_counts,
        params.normal_contamination,
        params.normal_cn,
        params.tumour_cn,
        params.species,
        params.species_assembly,
        params.normal_protocol,
        params.tumour_protocol,
        params.prior_mut_probability,
        params.prior_snp_probability,
        params.simrep,
        params.simrep_tbi,
        params.pindel_unmatch_panel,
        params.pindel_unmatch_panel_tbi,
        params.pindel_bad_loci,
        params.pindel_bad_loci_tbi,
        params.pindel_filter_rules,
        params.pindel_soft_filter_rules,
        params.genes,
        params.genes_tbi,
        params.sequencing_type,
        params.pindel_exclude,
        params.hidepth,
        params.hidepth_tbi,
        params.vagrent_dir,
        params.caveman_flag_bed_dir,
        params.caveman_flag_config,
        params.caveman_flag_to_vcf_config,
        params.caveman_unmatch_dir
    )
    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
        params.hook_url,
        null
    )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
