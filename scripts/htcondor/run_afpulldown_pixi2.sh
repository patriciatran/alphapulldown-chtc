#!/bin/bash
set -e

echo "DEBUG: reset HOME variable"
export HOME="$PWD"
echo $HOME

echo "DEBUG: Install pixi"
curl -fsSL https://pixi.sh/install.sh | PIXI_HOME=$PWD/scratch bash

source $PWD/.bashrc

export PATH="$PWD/scratch/bin:$PATH"

echo "DEBUG: User Pixi"
pixi --version

echo "DEBUG: Set up pixi envr"
mkdir af
pixi init af
cd af

echo "DEBUG: Add the dependencies"
pixi workspace channel add conda-forge
pixi workspace channel add bioconda

pixi add apptainer
pixi add snakedeploy

echo "DEBUG: Adding the packages acc to the AlphaPulldown yml file specification at https://github.com/KosinskiLab/AlphaPulldown/blob/main/environment.yml"

echo "DEBUG: Using pixi instead of conda"
pixi add python=3.12
pixi add snakemake=9.*
pixi add snakemake-executor-plugin-slurm
pixi add snakedeploy
pixi add pulp
pixi add click
pixi add coincbc
pixi add pip
# Note: if you forget to do this, the pipeline will not work because it won't have the alphapulldown-input-parser scripts.
# Install a pip package using pixi
pixi add --pypi "alphapulldown-input-parser>=0.3.0"

# If we had an interactive shell, we could type `pixi shell` and test our commands
# Because the job is non-interactive we need to ru use `pixi run` followed by the .sh script instead.  
echo "DEBUG: Start pixi run bash ../afp.sh"
pixi run bash ../afp.sh