# sangersomatic: Output

## Introduction

The directories listed below will be created in the results directory after the pipeline has finished. All paths are relative to the top-level results directory.


## Pipeline output overview

The pipeline is built using [Nextflow](https://www.nextflow.io/) and processes data using the following steps:

- [caveman_out](#caveman) - Call SNV mutations
- [pindel_out](#pindel) - Call Indel mutations
- [caveman_flagging_out](#caveman_flagging) - Flag SNVs using various sources, including outputs from PINDEL
- [Pipeline information](#pipeline-information) - Report metrics generated during the workflow execution

### caveman_out

<details markdown="1">
<summary>Output files</summary>

- `caveman_out/`
  - `sample_id/`
    - `alg_bean`: caveman set up output
    - `caveman.cfg.ini`: caveman set up output
    - `splitList`: caveman split output (this determines the number of jobs for CaVEMan Mstep and Estep)
    - `covs_arr`: caveman Mstep output (to be used in the Estep)
    - `probs_arr`: caveman Mstep output (to be used in the Estep)
    - `${sample_id}_vs_${match_normal_id}.caveman.muts.no_ids.vcf`: caveman Estep output (vcf for somatic mutations without added variant IDs)
    - `${sample_id}_vs_${match_normal_id}.caveman.snps.no_ids.vcf`: caveman Estep output (vcf for germline mutations without added variant IDs)
    -  `${sample_id}_vs_${match_normal_id}.no_analysis.bed.gz`: caveman Estep output
    - `${sample_id}_vs_${match_normal_id}.no_analysis.bed.gz.tbi`: caveman Estep output
    - `${sample_id}_vs_${match_normal_id}.muts.vcf.gz`: caveman add IDs output (bgzipped vcf for somatic mutations with variant IDs added)
    - `${sample_id}_vs_${match_normal_id}.muts.vcf.gz.tbi`: caveman add IDs output (bgzipped vcf index for somatic mutations with variant IDs added)
    - `${sample_id}_vs_${match_normal_id}.snps.vcf.gz`: caveman add IDs output (bgzipped vcf for germline mutations with variant IDs added)
    - `${sample_id}_vs_${match_normal_id}.snps.vcf.gz`: caveman add IDs output (bgzipped vcf index for germline mutations with variant IDs added)

### pindel_out

<details markdown="1">
<summary>Output files</summary>

- `pindel_out/`
  - `${sample_id}/`
    - `${sample_id}_vs_${match_normal_id}_mt.bam`: bam file for `sample_id`
    - `${sample_id}_vs_${match_normal_id}_mt.bam.bai`: bam index file for `sample_id`
    - `${sample_id}_vs_${match_normal_id}_wt.bam`: bam file for `match_normal_id`
    - `${sample_id}_vs_${match_normal_id}_wt.bam.bai`: bam index file for `match_normal_id`
    - `${sample_id}_vs_${match_normal_id}.germline.bed.gz`: bed file for germline mutation, this will be used to flag caveman output
    - `${sample_id}_vs_${match_normal_id}.germline.bed.gz.tbi`: index file for bed file for germline mutation, this will be used to flag caveman output
    - `${sample_id}_vs_${match_normal_id}.flagged.vcf.gz`: vcf file after running cgpPindel
    - `${sample_id}_vs_${match_normal_id}.flagged.vcf.gz.tbi`: index file for the vcf file after running cgpPindel
    - `${sample_id}_vs_${match_normal_id}.flagged.vafaugment.vcf.gz`: vcf file after vaf augmented (added VAF related flags)
    - `${sample_id}_vs_${match_normal_id}.flagged.vafaugment.vcf.gz.tbi`: index file for the vcf file after vaf augmented (added VAF related flags)
    - `${sample_id}_vs_${match_normal_id}.pindel.annot.flagged.vaf.vcf.gz`: vcf file after vaf augmented (added VAF related flags) and annotated with vagrent
    - `${sample_id}_vs_${match_normal_id}.pindel.annot.flagged.vaf.vcf.gz.tbi`: index file for the vcf file after vaf augmented (added VAF related flags) and annotated with vagrent



### caveman_flagging_out

<details markdown="1">
<summary>Output files</summary>

- `caveman_flagging_out/`
  - `sample_id/`
    - `${sample_id}_vs_${match_normal_id}.caveman.flagged.muts.vcf.gz`: output from caveman_flagging, VCF file flagged using various sources (see [caveman flagging script](../modules/local/caveman_flagging/main.nf)), this is input for the subsequent caveman_vagrent step
    - `${sample_id}_vs_${match_normal_id}.caveman.flagged.muts.vcf.gz.tbi`: output from caveman_flagging, index file for the VCF file flagged using various sources (see [caveman flagging script](../modules/local/caveman_flagging/main.nf)), this is input for the subsequent caveman_vagrent step
    - `${sample_id}_vs_${match_normal_id}.caveman.annot.flagged.muts.vcf.gz`: output from caveman_vagrent, ready for downstream analysis, VCF file flagged using vagrent (see [caveman vagrent annotating script](../modules/local/caveman_vagrent/main.nf))
    - `${sample_id}_vs_${match_normal_id}.caveman.annot.flagged.muts.vcf.gz.tbi`: output from caveman_vagrent, ready for downstream analysis, index file for VCF file flagged using vagrent (see [caveman vagrent annotating script](../modules/local/caveman_vagrent/main.nf))



### Pipeline information

<details markdown="1">
<summary>Output files</summary>

- `pipeline_info/`
  - Reports generated by Nextflow: `execution_report.html`, `execution_timeline.html`, `execution_trace.txt` and `pipeline_dag.dot`/`pipeline_dag.svg`.
  - Reports generated by the pipeline: `pipeline_report.html`, `pipeline_report.txt` and `software_versions.yml`. The `pipeline_report*` files will only be present if the `--email` / `--email_on_fail` parameter's are used when running the pipeline.
  - Reformatted samplesheet files used as input to the pipeline: `samplesheet.valid.csv`.
  - Parameters used by the pipeline run: `params.json`.

</details>

[Nextflow](https://www.nextflow.io/docs/latest/tracing.html) provides excellent functionality for generating various reports relevant to the running and execution of the pipeline. This will allow you to troubleshoot errors with the running of the pipeline, and also provide you with other information such as launch commands, run times and resource usage.
