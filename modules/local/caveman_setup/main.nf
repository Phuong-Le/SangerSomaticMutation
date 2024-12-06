process cavemanSetup {
    label 'caveman'
    label 'process_tiny'

    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'alg_bean', mode: params.publish_dir_mode
    publishDir "${params.outdir}/caveman_out/${meta.sample_id}", pattern: 'caveman.cfg.ini', mode: params.publish_dir_mode


    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match), path(sample_cn_file, stageAs: 'sample.cn.bed'), path(match_cn_file, stageAs: 'match.cn.bed')
    path fasta
    path filtered_fai
    path genome_gap


    output:
    tuple val(meta), path('alg_bean'), path('caveman.cfg.ini')

    script:
    """
    caveman setup --tumour-bam ${bam} --normal-bam ${bam_match} --reference-index ${filtered_fai} --ignore-regions-file ${genome_gap} --tumour-copy-no-file ${sample_cn_file} --normal-copy-no-file ${match_cn_file} --results-folder .
    rm -f ${bam} ${bai} ${bam_match} ${bai_match} ${sample_cn_file} ${match_cn_file} ${fasta} ${filtered_fai} ${genome_gap}
    """

}
