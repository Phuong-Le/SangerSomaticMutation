# sangersomatic: Usage


## Introduction

## Samplesheet input

The input sample sheet should be either in a tab delimited format (extension must be .tsv), or comma delimited format (extension must be .csv), like [samplesheet.tsv](../assets/samplesheet.tsv). Your input should contain the following columns (column names must be accurate but no need to be in this order, redundant columns will be ignored)

```tsv title="samplesheet.tsv"
sample_id	match_normal_id	bam	bai	bam_match	bai_match	sample_cn_file	match_cn_file
PD47151n_lo0002	PD47151b	/path/to/PD47151n_lo0002.small.bam	/path/to/PD47151n_lo0002.small.bam.bai	/path/to/PD47151b.small.bam	/path/to/PD47151b.small.bam.bai	/path/to/copynumber.bed	/path/to/copynumber.bed
PD52103n_lo0001	PD52103b	/path/to/PD52103n_lo0001.small.bam	/path/to/PD52103n_lo0001.small.bam.bai	/path/to/PD52103b.small.bam	/path/to/PD52103b.small.bam.bai	/path/to/copynumber.bed	/path/to/copynumber.bed
```

```bash
--input '[path to samplesheet file]'
```


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


## Other inputs

| Input Parameters    | Description                                                                                                                                                                            |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| REQUIRED PARAMS (must not be null, ie if no default, need to be defined by users in `nextflow run`) |
| `outdir`  | type: directory-path, The output directory where the results will be saved. You have to use absolute paths to storage on Cloud infrastructure |
| `sequencing_type` |  type: string, default: WGS (WGS/WXS), Sequencing protocol  |                                                            |
| `species` | type: string, Species name (eg Human), required if bam file does not contain AS (Genome assembly identifier) and SP (Species) information |                                                       |
| `species_assembly` | type: string, Species assembly (eg Human), required if bam file does not contain AS (Genome assembly identifier) and SP (Species) information |
| `max_read_counts` | type: integer, default: 500000, maximum read counts to input into caveman |
| `normal_contamination` | type: number, default: 0.1, match normal contamination in the sample/tumour to input into caveman estep |
| `normal_cn` | type: number, default: 2, copy number to use when filling gaps in the normal copy number file (see assets/schema_input.json)  to input into caveman estep |
| `tumour_cn` | type: number, default: 5, copy number to use when filling gaps in the tumour/samples copy number file (see assets/schema_input.json)  to input into caveman estep
| `normal_protocol` | type: string, default: WGS (WGS/WXS), normal sequencing protocol to input into caveman estep, (caveman: Ideally this should match tumour_protocol but not checked)
| `tumour_protocol` | type: string, default: WGS (WGS/WXS), tumour/sample sequencing protocol to input into caveman estep, (caveman: Ideally this should match tumour_protocol but not checked)
| `prior_mut_probability` | type: number, default: 0.000006, Prior somatic probability  to input into caveman estep
| `prior_snp_probability` | type: number, default: 0.0001, Prior germline mutant probability to input into caveman estep |
| OPTIONAL PARAMS |
| `image_cachedir`  | type: directory-path, /path/to/SangerSomaticMutation/image if a container runtime profile or is enabled or conf/container.config is loaded, eg with --profile singularity |
| `use_custom_genome` |  type: boolean, default: false, whether to use custom genome as specified in conf/custom_ref_genomes.config  |
| REFERENCE GENOME REQUIRED PARAMS |                                                          |
| `fasta` | type: file-path, Path to FASTA genome file |
| `fai` | type: file-path, Path to FASTA genome index (fa.fai) file. |
| `hidepth` | type: file-path, Path to high depth region, used in vafAugment under PINDEL |
| `hidepth_tbi` | type: file-path, Path to high depth region index (bed.tbi), used in vafAugment under PINDEL |
| `genome_gap` | type: file-path, Path to genome gap tab delimited file (genome.gap.tab) |
| `caveman_ignore_contigs` | type: file-path, Path to the ignore contig file specific for caveman |
| `simrep` | type: file-path, Path to tabix indexed simple/satellite repeats |
| `simrep_tbi` | type: file-path, Path to tabix index file for the simple/satellite repeats |
| `pindel_unmatch_panel` | type: file-path, Path to tabix indexed gff3 or bed of unmatched normal panel (see also pindel_np_from_vcf.pl) |
| `pindel_unmatch_panel_tbi` | type: file-path, Path to index for tabix indexed gff3 or bed of unmatched normal panel (see also pindel_np_from_vcf.pl) |
| `pindel_bad_loci` | type: file-path, Tabix indexed BED file of locations to not accept as anchors |
| `pindel_bad_loci_tbi` | type: file-path, Tabix file of for locations to not accept as anchors |
| `pindel_filter_rules` | type: file-path,VCF filter rules file (see FlagVcf.pl for details) |
| `pindel_soft_filter_rules` | type: file-path, Filter rules to be indicated in INFO field as soft flags |
| `genes` | type: file-path, Tabix indexed coding gene footprints |
| `genes_tbi` | type: file-path, Tabix file for coding gene footprints |
| `vagrent_dir` | type: directory-path, vagrent directory - should contain a vagrent cache file |
| `caveman_flag_bed_dir` | type: directory-path, directory to bed files to flag caveman output |
| `caveman_flag_config` | type: file-path, caveman flag config |
| `caveman_flag_to_vcf_config` | type: file-path, caveman flag to vcf config |
| `caveman_unmatch_dir` | type: directory-path, directory to caveman unmatch panel |
| REFERENCE GENOME OPTIONAL PARAMS |                                                          |
| `genome` | type: string, If using a reference genome configured in the pipeline using `--use_custom_genome true` (ie `conf/custom_ref_genomes.config` is loaded) or iGenomes, use this parameter to give the ID/label for the reference. This is then used to build the full paths for all required reference genome files e.g. `--genome GRCh38`.  |
| `igenomes_ignore` | type: boolean, default: true, Do not load `igenomes.config` when running the pipeline. You may choose this option if you observe clashes between custom parameters and those supplied in `igenomes.config` |
| `igenomes_base` | type: directory-path, default: "s3://ngi-igenomes/igenomes/", The base path to the igenomes reference files, ignored when `--igenomes-ignore` is enabled |
| `custom_genome_base` | type: directory-path, default: null, The base path to the custom genome reference files (REQUIRED IF `--use_custom_genome true` AND if used to build the full path in the reference genome profile in [conf/custom_ref_genomes.config](conf/custom_ref_genomes.config)) |

There are two ways to set up the REFERENCE GENOME REQUIRED PARAMS,

1. Directly specify them in the nextflow command line (or `-params-file`)

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
  --input ./samplesheet.csv \
  --outdir /path/to/outdir \
  --species Human \
  --species_assembly GRCh38 \
  --fasta /path/to/reference/fasta \
  --fai /path/to/reference/fasta \
  ...
  --caveman_unmatch_dir /path/to/caveman/unmatch/dir
```

2. Set up a custom reference genome profile

Edit the [conf/custom_ref_genomes.config](../conf/custom_ref_genomes/config) file (eg by fill in the `your_genome_label` section). "your_genome_label" is the name of the genome profile that you want to set up, specified by `--genome your_genome_label`. For each item under "your_genome_label", you can specify the path to the right file or directory. If they are all under one parent directory, you can use the `--custom_genome_base` parameter to build the full path (like in "GRCh38_full_analysis_set_plus_decoy_hla")

You can then run the pipeline like this

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
   -profile <docker/singularity/.../institute> \
   --input /path/to/samplesheet.csv \
   --species Human \
   --species_assembly GRCh38 \
   --use_custom_genome true \
   --genome genome_label_in_custom_genome_config \ #eg your_genome_label
   --outdir /path/to/outdir
```

or like this if there's a `custom_genome_base` required

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
   -profile <docker/singularity/.../institute> \
   --input /path/to/samplesheet.csv \
   --species Human \
   --species_assembly GRCh38 \
   --use_custom_genome true \
   --genome genome_label_in_custom_genome_config \ #eg your_genome_label
   --custom_genome_base /path/to/custom/genome/directory \
   --outdir /path/to/outdir
```


## Running the pipeline

You can specify a `-profile`  option as follows

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
   -profile <docker/singularity/.../institute> \
   --input /path/to/samplesheet.csv \
   --species Human \
   --species_assembly GRCh38 \
   --use_custom_genome true \
   --genome genome_label_in_custom_genome_config \ #eg your_genome_label
   --custom_genome_base /path/to/custom/genome/directory \
   --outdir /path/to/outdir \
   -profile docker
```

This will launch the pipeline with the `docker` configuration profile. See below for more information about profiles.

Note that the pipeline will create the following files in your working directory:

```bash
work                # Directory containing the nextflow working files
<OUTDIR>            # Finished results in specified location (defined with --outdir)
.nextflow_log       # Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

If you wish to repeatedly use the same parameters for multiple runs, rather than specifying each flag in the command, you can specify these in a params file.

Pipeline settings can be provided in a `yaml` or `json` file via `-params-file <file>`.

:::warning
Do not use `-c <file>` to specify parameters as this will result in errors. Custom config files specified with `-c` must only be used for [tuning process resource specifications](https://nf-co.re/docs/usage/configuration#tuning-workflow-resources), other infrastructural tweaks (such as output directories), or module arguments (args).
:::

The above pipeline run specified with a params file in yaml format:

```bash
nextflow run sangersomatic -profile docker -params-file params.yaml
```

with:

```yaml title="params.yaml"
input: './samplesheet.csv'
outdir: './results/'
genome: 'GRCh38'
<...>
```


### Updating the pipeline

When you run the above command, Nextflow automatically pulls the pipeline code from GitHub and stores it as a cached version. When running the pipeline after this, it will always use the cached version if available - even if the pipeline has been updated since. To make sure that you're running the latest version of the pipeline, make sure that you regularly update the cached version of the pipeline:

```bash
cd /path/to/SangerSomaticMutation/dir
git pull
```

<!-- ### Reproducibility

It is a good idea to specify a pipeline version when running the pipeline on your data. This ensures that a specific version of the pipeline code and software are used when you run your pipeline. If you keep using the same tag, you'll be running the same version of the pipeline, even if there have been changes to the code since.

First, go to the [nf-core/sangersomatic releases page](https://github.com/nf-core/sangersomatic/releases) and find the latest pipeline version - numeric only (eg. `1.3.1`). Then specify this when running the pipeline with `-r` (one hyphen) - eg. `-r 1.3.1`. Of course, you can switch to another version by changing the number after the `-r` flag.

This version number will be logged in reports when you run the pipeline, so that you'll know what you used when you look back in the future. For example, at the bottom of the MultiQC reports.

To further assist in reproducbility, you can use share and re-use [parameter files](#running-the-pipeline) to repeat pipeline runs with the same settings without having to write out a command with every single parameter. -->

:::tip
If you wish to share such profile (such as upload as supplementary material for academic publications), make sure to NOT include cluster specific paths to files, nor institutional specific profiles.
:::

## Core Nextflow arguments

:::note
These options are part of Nextflow and use a _single_ hyphen (pipeline parameters use a double-hyphen).
:::

### `-profile`

Use this parameter to choose a configuration profile. Profiles can give configuration presets for different compute environments.

Several generic profiles are bundled with the pipeline which instruct the pipeline to use software packaged using different methods (Docker, Singularity, Podman, Shifter, Charliecloud, Apptainer, Conda) - see below.

:::info
We highly recommend the use of Docker or Singularity containers for full pipeline reproducibility, however when this is not possible, Conda is also supported.
:::

The pipeline also dynamically loads configurations from [https://github.com/nf-core/configs](https://github.com/nf-core/configs) when it runs, making multiple config profiles for various institutional clusters available at run time. For more information and to see if your system is available in these configs please see the [nf-core/configs documentation](https://github.com/nf-core/configs#documentation).

Note that multiple profiles can be loaded, for example: `-profile test,docker` - the order of arguments is important!
They are loaded in sequence, so later profiles can overwrite earlier profiles.

If `-profile` is not specified, the pipeline will run locally and expect all software to be installed and available on the `PATH`. This is _not_ recommended, since it can lead to different results on different machines dependent on the computer enviroment.

- `test`
  - A profile with a complete configuration for automated testing
  - Includes links to test data so needs no other parameters
- `docker`
  - A generic configuration profile to be used with [Docker](https://docker.com/)
- `singularity`
  - A generic configuration profile to be used with [Singularity](https://sylabs.io/docs/)
- `podman`
  - A generic configuration profile to be used with [Podman](https://podman.io/)
- `shifter`
  - A generic configuration profile to be used with [Shifter](https://nersc.gitlab.io/development/shifter/how-to-use/)
- `charliecloud`
  - A generic configuration profile to be used with [Charliecloud](https://hpc.github.io/charliecloud/)
- `apptainer`
  - A generic configuration profile to be used with [Apptainer](https://apptainer.org/)
- `wave`
  - A generic configuration profile to enable [Wave](https://seqera.io/wave/) containers. Use together with one of the above (requires Nextflow ` 24.03.0-edge` or later).
- `conda`
  - A generic configuration profile to be used with [Conda](https://conda.io/docs/). Please only use Conda as a last resort i.e. when it's not possible to run the pipeline with Docker, Singularity, Podman, Shifter, Charliecloud, or Apptainer.

### `-resume`

Specify this when restarting a pipeline. Nextflow will use cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously. For input to be considered the same, not only the names must be identical but the files' contents as well. For more info about this parameter, see [this blog post](https://www.nextflow.io/blog/2019/demystifying-nextflow-resume.html).

You can also supply a run name to resume a specific run: `-resume [run-name]`. Use the `nextflow log` command to show previous run names.

### `-c`

Specify the path to a specific config file (this is a core Nextflow command). See the [nf-core website documentation](https://nf-co.re/usage/configuration) for more information.

## Custom configuration

### Resource requests

Whilst the default requirements set within the pipeline will hopefully work for most people and with most input data, you may find that you want to customise the compute resources that the pipeline requests. Each step in the pipeline has a default set of requirements for number of CPUs, memory and time. For most of the steps in the pipeline, if the job exits with any of the error codes specified [here](https://github.com/nf-core/rnaseq/blob/4c27ef5610c87db00c3c5a3eed10b1d161abf575/conf/base.config#L18) it will automatically be resubmitted with higher requests (2 x original, then 3 x original). If it still fails after the third attempt then the pipeline execution is stopped.

To change the resource requests, please see the [max resources](https://nf-co.re/docs/usage/configuration#max-resources) and [tuning workflow resources](https://nf-co.re/docs/usage/configuration#tuning-workflow-resources) section of the nf-core website.

### Custom Containers

In some cases you may wish to change which container or conda environment a step of the pipeline uses for a particular tool. By default nf-core pipelines use containers and software from the [biocontainers](https://biocontainers.pro/) or [bioconda](https://bioconda.github.io/) projects. However in some cases the pipeline specified version maybe out of date.

To use a different container from the default container or conda environment specified in a pipeline, please see the [updating tool versions](https://nf-co.re/docs/usage/configuration#updating-tool-versions) section of the nf-core website.

### Custom Tool Arguments

A pipeline might not always support every possible argument or option of a particular tool used in pipeline. Fortunately, nf-core pipelines provide some freedom to users to insert additional parameters that the pipeline does not include by default.

To learn how to provide additional arguments to a particular tool of the pipeline, please see the [customising tool arguments](https://nf-co.re/docs/usage/configuration#customising-tool-arguments) section of the nf-core website.

### nf-core/configs

In most cases, you will only need to create a custom config as a one-off but if you and others within your organisation are likely to be running nf-core pipelines regularly and need to use the same settings regularly it may be a good idea to request that your custom config file is uploaded to the `nf-core/configs` git repository. Before you do this please can you test that the config file works with your pipeline of choice using the `-c` parameter. You can then create a pull request to the `nf-core/configs` repository with the addition of your config file, associated documentation file (see examples in [`nf-core/configs/docs`](https://github.com/nf-core/configs/tree/master/docs)), and amending [`nfcore_custom.config`](https://github.com/nf-core/configs/blob/master/nfcore_custom.config) to include your custom profile.

See the main [Nextflow documentation](https://www.nextflow.io/docs/latest/config.html) for more information about creating your own configuration files.

If you have any questions or issues please send us a message on [Slack](https://nf-co.re/join/slack) on the [`#configs` channel](https://nfcore.slack.com/channels/configs).

## Running in the background

Nextflow handles job submissions and supervises the running jobs. The Nextflow process must run until the pipeline is finished.

The Nextflow `-bg` flag launches Nextflow in the background, detached from your terminal so that the workflow does not stop if you log out of your session. The logs are saved to a file.

Alternatively, you can use `screen` / `tmux` or similar tool to create a detached session which you can log back into at a later time.
Some HPC setups also allow you to run nextflow within a cluster job submitted your job scheduler (from where it submits more jobs).


