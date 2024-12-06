process cavemanSplitConcat {
    label 'process_tiny'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'splitList', mode: params.publish_dir_mode

    input:
    tuple val(meta), path(readpos), path(splitlist)
    path(filter_genome_index)

    output:
    tuple val(meta), path(readpos), path('splitList')

    script:
    """
    caveman_split_concat.sh
    rm -f ${splitlist} ${filter_genome_index}
    """
}
