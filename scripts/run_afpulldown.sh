#!/bin/bash

set -e

export HOME="$PWD"
export PATH=/opt/apptainer/bin:/opt/conda/envs/snake/bin:$PATH
export PYTHONPATH=/opt/conda/envs/snake/lib/python3.11/site-packages
#export PATH=/opt/apptainer/bin:$PATH
echo $PATH
echo $HOME

echo "DEBUG: Check snakemake version"
which snakemake
snakemake -v

echo "DEBUG: Check Apptainer version"
which apptainer
apptainer -v

echo "DEBUG: Check snakedeploy"
which snakedeploy
snakedeploy --help

echo "DEBUG: Test Apptainer"
apptainer exec --unsquash --pid --ipc docker://ubuntu:latest echo "Running with options --unsquash --pid --ipc"

echo "DEBUG: Get workflow scripts"
snakedeploy deploy-workflow \
  https://github.com/KosinskiLab/AlphaPulldownSnakemake \
  AlphaPulldownSnakemake \
  --tag 2.1.8

#wget https://github.com/KosinskiLab/AlphaPulldownSnakemake/archive/refs/tags/2.1.8.tar.gz
#tar -xf 2.1.8.tar.gz
#cd AlphaPulldownSnakemake-2.1.8

echo "DEBUG: Transfer input files to the correct subfolder locations"
#cat AlphaPulldownSnakemake-2.1.8/config/config.yaml
#cat AlphaPulldownSnakemake-2.1.8/config/sample_sheet.csv
#cp config.yaml AlphaPulldownSnakemake-2.1.8/config/config.yaml

#mv baits.txt AlphaPulldownSnakemake/baits.txt
#mv folds.txt AlphaPulldownSnakemake/folds.txt

cat AlphaPulldownSnakemake/config/config.yaml
cp config.yaml AlphaPulldownSnakemake/config/config.yaml
cat AlphaPulldownSnakemake/config/config.yaml

echo "DEBUG: Set Cache DIR"
export SINGULARITY_CACHEDIR=$PWD/cache
mkdir -p SINGULARITY_CACHEDIR
echo $SINGULARITY_CACHEDIR

echo "DEBUG: Moving into the directory"
cd AlphaPulldownSnakemake
echo "DEBUG: Path is: $(pwd)"

echo "DEBUG: Run the script"
snakemake --profile config/profiles/desktop \
	--cores 8 \
	--use-singularity \
	--singularity-args "--unsquash --pid --ipc"

echo "DEBUG: Show folder contents: $(ls)"

ls output_afp

echo "DEBUG: Zip output:"
tar cvf output_afp.tar.gz output_afp


