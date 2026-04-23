# Alphapulldown on CHTC

Example code on how to run Alphapulldown on CHTC

**Current status**: Testing this in a non-interactive job.

# Files

## Submit file


`.sub`

the submit file should have a requirement for the af3 database
the submit file should also request a node with GPU

## Executable files

`.sh` files

the main .sh file installs pixi directly on the matched node
it also sets up a pixi project and install the required dependencies
those dependencies are:
- snakemake
- apptainer
- and all the ones listed in the conda yml file of alphapulldown
    - the packages are added via `pixi add` instead

Because HTcondor runs things non-interactively, using `pixi shell` will throw an error.
Therefore, the script should run any code as `pixi run bash [bash script]`, where the bash script contains the actual `snakedeploy` and `snakemake` commands.

`afp.sh`
- things worth mentioning are the extra apptainer parameters passed onto snakemake using :
```
  --singularity-args "--nv --unsquash --pid --ipc --env PREPEND_PATH=/opt/venv/bin:/opt/conda/bin -B $(pwd):$(pwd) --cwd $(pwd)"
```

Specifically, we request that apptainer uses a sandbox environment, and we need to pass on some specific paths to snakemake using `PREPEND_PATH`. 

## Config files

Use the config file template from the AlphaPulldown repository.
To run on CHTC, make sure to change the following variables:

```
databases_directory: /alphafold3
# Weights should be requested by each user ahead of time.
backend_weights_directory: /path/in/staging/netid/af3.bin.zst
# Pick alphafold3 
structure_inference_arguments:
  --fold_backend: alphafold3
```

the config file should be prepared ahead of time, and passed onto the job as part of the `transfer_input_files` line of the submit file.


# Other options tested that did not work (or that caused other issues)

Before landing on using `pixi`, we also attempted:

- making a docker image containing all the deps
- making an apptainer image containing all the deps

Typical errors included mismatches in environment variables, which ones were passed onto other programs, etc.