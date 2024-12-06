
As per the main [docs/usage.md](../docs/usage.md) document, it is recommended to have this line in your `~/.bashrc` file

```bash
NXF_OPTS='-Xms1g -Xmx4g'
```

On the Sanger Farm you need to specify the user group to submit jobs. Since Nextflow does this for you, you need to set a default user group in your `~/.bashrc` like this so Farm understands which group you're running your jobs under

```bash
export LSB_DEFAULT_USERGROUP=your-unix-group
```

Of course, remember to `source ~/.bashrc` the first time you run this pipeline, you don't have to do this again next time you log in.
