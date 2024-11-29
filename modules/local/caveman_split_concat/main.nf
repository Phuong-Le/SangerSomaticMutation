process cavemanSplitConcat {
    publishDir "${params.outdir}/${meta.sample_id}"

    input:
    tuple val(meta), path(readpos), path(splitlist)
    path(filter_genome_index)

    output:
    tuple val(meta), path(readpos), path('splitList')

    script:
    """
    caveman_split_concat.sh
    """
}
