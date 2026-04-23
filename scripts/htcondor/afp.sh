echo "DEBUG: Verify that the softwares are installed properly"
snakemake -h
apptainer -h
snakedeploy -h

echo "DEBUG: Testing running an apptainer container inside of pixi environment"
apptainer exec --unsquash --pid --ipc docker://ubuntu:latest echo "Running with options --unsquash --pid --ipc"

echo "DEBUG: User Snakedeploy to get a local copy of AlphaPulldown"
snakedeploy deploy-workflow \
  https://github.com/KosinskiLab/AlphaPulldownSnakemake \
  AlphaPulldownSnakemake \
  --tag 2.1.8

echo "DEBUG: Check the config files, verify that the af3 database points to the correct location."
cat AlphaPulldownSnakemake/config/config.yaml
cp ../config.yaml AlphaPulldownSnakemake/config/config.yaml
cat AlphaPulldownSnakemake/config/config.yaml

echo "DEBUG: Set Cache DIR"
export SINGULARITY_CACHEDIR=$PWD/cache
mkdir -p $SINGULARITY_CACHEDIR

echo "DEBUG: Entering AlphaPulldown folder"
cd AlphaPulldownSnakemake/

echo "DEBUG: Start Snakemake Run"
snakemake --profile config/profiles/desktop \
  --cores 8 \
  --use-singularity \
  --singularity-args "--nv --unsquash --pid --ipc --env PREPEND_PATH=/opt/venv/bin:/opt/conda/bin -B $(pwd):$(pwd) --cwd $(pwd)"
  
echo "For reproducibility, get a copy of the pixi.toml and the pixi.lock files"
cd ~
tar -cf afp_pixi_env.tar.gz af/AlphaPulldownSnakemake/temp_fold af/pixi.toml af/pixi.lock