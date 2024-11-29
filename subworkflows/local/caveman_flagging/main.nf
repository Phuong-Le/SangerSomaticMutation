include { cavemanFlagging } from "$projectDir/modules/local/caveman_flagging"
include { cavemanVagrent } from "$projectDir/modules/local/caveman_vagrent"


workflow CAVEMAN_FLAGGING {
    take:
    ch_samplesheet
    fasta
    fai
    caveman_flag_bed_dir
    vagrent_dir
    caveman_flag_config
    caveman_flag_to_vcf_config
    caveman_unmatch_dir
    species
    sequencing_type

    main:
    cavemanFlagging(
        ch_samplesheet,
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

    cavemanVagrent(
        cavemanFlagging.out,
        vagrent_dir
    )

}
