include { cgpPindel } from "${projectDir}/modules/local/cgppindel"
include { cgpBigWig as cgpBigWigSample } from "$projectDir/modules/local/cgpbigwig"
include { cgpBigWig as cgpBigWigMatch } from "$projectDir/modules/local/cgpbigwig"
include { vafAugment } from "$projectDir/modules/local/vaf_augment"
include { pindelVagrent } from "$projectDir/modules/local/pindel_vagrent"

workflow PINDEL {
    take:
    ch_samplesheet
    fasta
    fai
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
    species
    species_assembly
    sequencing_type
    pindel_exclude
    hidepth
    hidepth_tbi
    vagrent_dir

    main:

    cgpPindel(
        ch_samplesheet,
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
        pindel_exclude
    )


    // cgpBigWigSample(
    //     cgpPindel.out.bams
    //     .map { meta, mt_bam, mt_bai, wt_bam, wt_bai -> tuple(meta, mt_bam, mt_bai) },
    //     fasta,
    //     fai
    // )

    // cgpBigWigMatch(
    //     cgpPindel.out.bams
    //     .map { meta, mt_bam, mt_bai, wt_bam, wt_bai -> tuple(meta, wt_bam, wt_bai) },
    //     fasta,
    //     fai
    // )

    vafAugment(
        ch_samplesheet
        .join(cgpPindel.out.vcfs),
        fasta,
        fai,
        hidepth,
        hidepth_tbi
    )

    pindelVagrent(
        vafAugment.out,
        vagrent_dir
    )


    emit:
    pindel_germline_bed = cgpPindel.out.germline_beds

}
