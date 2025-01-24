include { filterGenomeIndex } from "${projectDir}/modules/local/filter_genome_index"
include { cavemanSetup } from "${projectDir}/modules/local/caveman_setup"
include { cavemanSplit } from "${projectDir}/modules/local/caveman_split"
include { cavemanSplitConcat } from "${projectDir}/modules/local/caveman_split_concat"
include { cavemanMstep } from "${projectDir}/modules/local/caveman_mstep"
include { cavemanMergeMstep } from "${projectDir}/modules/local/caveman_merge_mstep"
include { cavemanEstep } from "${projectDir}/modules/local/caveman_estep"
include { cavemanMergeEstep } from "${projectDir}/modules/local/caveman_merge_estep"
include { cavemanAddIDS } from "${projectDir}/modules/local/caveman_add_ids"

workflow CAVEMAN {
    take:
    ch_samplesheet
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

    main:

    filterGenomeIndex(fai, caveman_ignore_contigs)

    cavemanSetup(
        ch_samplesheet,
        fasta,
        filterGenomeIndex.out,
        genome_gap
        )

    // get the line indices in the genome index file
    genome_index = filterGenomeIndex.out
        .countLines()
        .map { (1..it).toList() }
        .flatten()

    cavemanSplit(
        genome_index.combine(
            ch_samplesheet
            .join(cavemanSetup.out)
        ),
        max_read_counts,
        fasta,
        filterGenomeIndex.out,
        genome_gap
    )

    cavemanSplitConcat(
        cavemanSplit.out
        .map{ index, meta, readpos, splitlist -> tuple(meta, readpos, splitlist) }
        .groupTuple( by: 0 ),
        filterGenomeIndex.out
    )

    splitlist_ch = cavemanSplitConcat.out
        .flatMap{ meta, readpos, splitlist ->
            splitlist
            .splitCsv(header:['chrom', 'starts', 'ends'], sep: '\t')
            .withIndex(1)*.reverse()
            .collect{
                tuple(meta, it[1].chrom, it[0], it[1], readpos.find{ filename ->  filename.name =~ /readpos\.${it[1].chrom}$/ }, splitlist )
            }
        }
        .groupTuple( by: [0,1] )
        .map {
            meta, chrom, indices, entry, readpos, splitlist ->
            tuple(meta, chrom, indices, entry, readpos[0], splitlist[0])
        }


    cavemanMstep(
        splitlist_ch
        .combine(
            ch_samplesheet
            .join(cavemanSetup.out),
            by:0
            ),
        fasta,
        filterGenomeIndex.out,
        genome_gap
    )

    cavemanMergeMstep(
        cavemanMstep.out
        .groupTuple(by: 0)
        .join(
            cavemanSetup.out
            .join(cavemanSplitConcat.out)
        )
    )


    cavemanEstep(
        splitlist_ch
        .combine(
            cavemanMstep.out,
            by: [0, 1]
        )
        .combine(ch_samplesheet, by: 0)
        .combine(cavemanSetup.out, by : 0)
        .combine(cavemanMergeMstep.out, by: 0),
        fasta,
        filterGenomeIndex.out,
        genome_gap,
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

    cavemanMergeEstep(
        cavemanEstep.out
        .groupTuple( by:0 )
        .join(
            cavemanSetup.out
            .join(cavemanSplitConcat.out)
        )
    )

    cavemanAddIDS(
        cavemanMergeEstep.out
    )

    emit:
    cavemanAddIDS.out
}
