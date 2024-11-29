process filterGenomeIndex {
    publishDir "${params.outdir}", pattern: 'genome.fa.fai', saveAs: {'filtered_genome.fa.fai'}

    input:
    path fai, stageAs: 'full_genome.fa.fai'
    path caveman_ignore_contigs

    output:
    path 'genome.fa.fai'

    script:
    "grep -vFwf ${caveman_ignore_contigs} $fai > genome.fa.fai"
}
