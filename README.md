<h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/images/nf-core-sangersomatic_logo_dark.png">
    <img alt="nf-core/sangersomatic" src="docs/images/nf-core-sangersomatic_logo_light.png">
  </picture>
</h1>

<!-- [![GitHub Actions CI Status](https://github.com/nf-core/sangersomatic/actions/workflows/ci.yml/badge.svg)](https://github.com/nf-core/sangersomatic/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/nf-core/sangersomatic/actions/workflows/linting.yml/badge.svg)](https://github.com/nf-core/sangersomatic/actions/workflows/linting.yml)[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/sangersomatic/results)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com) -->

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A524.04.2-23aa62.svg)](https://www.nextflow.io/)
<!-- [![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/) -->
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/nf-core/sangersomatic)

<!-- [![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23sangersomatic-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/sangersomatic)[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)[![Follow on Mastodon](https://img.shields.io/badge/mastodon-nf__core-6364ff?labelColor=FFFFFF&logo=mastodon)](https://mstdn.science/@nf_core)[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core) -->

## Introduction

**nf-core/sangersomatic** is a bioinformatics pipeline that calls somatic mutations from bam files, using CaVEMan to call SNVs and Pindel to call Indels

<!-- TODO nf-core:
   Complete this sentence with a 2-3 sentence summary of what types of data the pipeline ingests, a brief overview of the
   major pipeline sections and the types of output it produces. You're giving an overview to someone new
   to nf-core here, in 15-20 seconds. For an example, see https://github.com/nf-core/rnaseq/blob/master/README.md#introduction
-->

<!-- TODO nf-core: Include a figure that guides the user through the major workflow steps. Many nf-core
     workflows use the "tube map" design for that. See https://nf-co.re/docs/contributing/design_guidelines#examples for examples.   -->
<!-- TODO nf-core: Fill in short bullet-pointed list of the default steps in the pipeline -->

1. Run CaVEMan, an EM-based algorithm to call SNVs somatic mutations, including:
  - setup: sets up configuration for subsequent steps
  - split: splits the input bam file into chunks, each task do this per line in the input genome index file (eg genome.fa.fai)
  - split concat: concatenate results from the above different split jobs, outputs a single `splitFile` for subsequent steps
  - Mstep: maximisation step, each task do this per line in the `splitFile`
  - Merge Mstep: concatenate results from the above different Mstep jobs, outputs a single `covs_array` file and a `probs_array` file  for subsequent steps
  - Estep: expectation step, each task do this per line in the `splitFile`
  - Merge Estep: concatenate results from the above different split jobs, outputs a single `muts.no_ids.vcf` file for somatics mutations, a single `snps.no_ids.vcf` file for SNPs (germline), a single `bed.gz` and its index file `bed.gz.tbi`
  - Add IDS: add ids to the above `no_ids.vcf` files, bgzip and tabix index them to obtain a `muts.vcf.gz` file, a `muts.vcf.gz.tbi` file, a `snps.vcf.gz` file and a `snps.vcf.gz.tbi` file.

2. Run [Pindel](https://github.com/genome/pindel), including:
  - Pindel itself through [cgpPindel](https://github.com/cancerit/cgpPindel) to call Indels, this also outputs a `germline.bed.gz` file and its tabix index file `germline.bed.gz` for the downstream cgpCaVEManPostProcessing step
  - Add some [vafCorrect](https://github.com/cancerit/vafCorrect) flags to the VCF files
  - Flagging of the output VCF files with [VAGrENT](https://github.com/cancerit/VAGrENT)

3. Run [cgpCaVEManPostProcessing](https://github.com/cancerit/cgpCaVEManPostProcessing)

## Dependencies

- Nextflow >= 24.04.2 required

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow.

The following does not need to be installed if using a container runtime like Docker or Singularity

- [CaVEMan](https://github.com/cancerit/CaVEMan)
- [cgpPindel](https://github.com/cancerit/cgpPindel)
- [PCAP-core](https://github.com/cancerit/PCAP-core)
- [vafCorrect](https://github.com/cancerit/vafCorrect)
- [VAGrENT](https://github.com/cancerit/VAGrENT)
- [cgpCaVEManPostProcessing](https://github.com/cancerit/cgpCaVEManPostProcessing)

## Installation

```
git clone git@github.com:Phuong-Le/SangerSomaticMutation.git
```

## Usage


> [NOT PUBLIC YET] Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

The input sample sheet should be either in a tab delimited format (extension must be .tsv), or comma delimited format (extension must be .csv), like [samplesheet.tsv](assets/samplesheet.tsv). Your input should contain the following columns (column names must be accurate but no need to be in this order, redundant columns will be ignored)

| Column    | Description                                                                                                                                                                            |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sample_id`  | sample ID, must be unique |
| `match_normal_id` |  ID for your match normal sample |                                                            |
| `bam` | bam file for `sample_id`, must exist |                                                       |
| `bai` | tabix index file for `bam`, must exist |
| `bam_match` | bam file for `match_normal_id`, must exist |
| `bai_match` | tabix index file for `bam_match`, must exist |
| `sample_cn_file` | copy number file for `sample_id`, must exist, can be an empty file (like [empty.cn.bed](assets/empty.cn.bed)) |
| `match_cn_file` | copy number file for `match_normal_id`, must exist, can be an empty file (like [empty.cn.bed](assets/empty.cn.bed)) |


Please find the detailed instructions to run the pipeline, including the input parameters in [docs/usage.md](docs/usage.md). You can run the pipeline using:

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
   -profile <docker/singularity/.../institute> \
   --input /path/to/samplesheet.csv \
   --species Human \
   --species_assembly GRCh38 \
   --use_custom_genome true \ # see notes below
   --genome genome_label_in_custom_genome_config \ # see notes below
   --outdir /path/to/outdir
```

The following required parameters can be specified either directly via the `nextflow run` command, or via a custom genome profile like in the above example (this involves setting `use_custom_genome` to true and specifying the `genome` label - detailed instructions to create a custom genome profile can be found in [docs/usage.md](docs/usage.md))

```
--fasta
--fai
--hidepth
--hidepth_tbi
--genome_gap
--caveman_ignore_contigs
--simrep
--simrep_tbi
--pindel_unmatch_panel
--pindel_unmatch_panel_tbi
--pindel_bad_loci
--pindel_bad_loci_tbi
--pindel_soft_filter_rules
--genes
--genes_tbi
--pindel_exclude
--vagrent_dir
--caveman_flag_bed_dir
--caveman_flag_config
--caveman_flag_to_vcf_config
--caveman_umatch_dir
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/usage/getting_started/configuration#custom-configuration-files).


## Sanger users

Sanger users can run the pipeline as follows. Please refer to [docs/sanger.md](docs/sanger.md) to ensure you have the right set up.

```
module load cellgen/nextflow/24.10.2
module load ISG/singularity/3.11.4

outdir=/path/to/outdir
mkdir -p $outdir
script=/path/to/SangerSomaticMutation/main.nf # should be part of this pipeline
config_file=/path/to/sanger_lsf.config # should be part of this pipeline
samplesheet=/path/to/samplesheet.tsv # or .csv, format should be consistent with extension
species=Human # please refer to docs/usage.md
species_assembly=GRCh38 # please refer to docs/usage.md
custom_genome_base=/lustre/scratch124/casm/team78pipelines/canpipe/live/ref/Homo_sapiens # please let me know if you're using a different genome so I can update the config for you
genome=GRCh38_full_analysis_set_plus_decoy_hla # same as above


bsub -cwd $outdir -q week -o %J.o -e %J.e -R'span[hosts=1] select[mem>10000] rusage[mem=10000]' -M10000 -env "all" \
    "nextflow run ${script} -c ${config_file}  --input ${samplesheet} --outdir ${outdir} --use_custom_genome true --custom_genome_base ${custom_genome_base} --genome ${genome} -profile singularity --species ${species} --species_assembly ${species_assembly} -resume"

```

## Pipeline output

To see the results of an example test run with a full size dataset refer to the [results](https://nf-co.re/sangersomatic/results) tab on the nf-core website pipeline page.
For more details about the output files and reports, please refer to the
[output documentation](https://nf-co.re/sangersomatic/output).

## Credits

Sangersomatic was originally written by Phuong Le.

We thank the following people for their extensive assistance in the development of this pipeline:

Alex Byrne
Andy Menzies

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Contributions and Support

Please feel free to contribute by either creating a pull request or create a new issue on this github repo

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use nf-core/sangersomatic for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

<!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

