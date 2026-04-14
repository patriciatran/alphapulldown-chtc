# 1. Start with a Conda-ready base image (AMD64)
FROM --platform=linux/amd64 mambaorg/micromamba:latest

USER root

# 2. Install system tools required for Apptainer install script
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl rpm2cpio cpio libfuse2 squashfs-tools git rsync \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://raw.githubusercontent.com/KosinskiLab/AlphaPulldownSnakemake/2.1.8/workflow/envs/alphapulldown.yaml -o /tmp/env.yaml

# 3. Create the environment using the local file
RUN micromamba create -y -n snake -f /tmp/env.yaml \
    && micromamba clean --all --yes

# 4. Install Apptainer (Unprivileged)
RUN mkdir -p /opt/apptainer && \
    curl -s https://raw.githubusercontent.com/apptainer/apptainer/main/tools/install-unprivileged.sh | \
    bash -s - /opt/apptainer

# 5. Set the PATH so everything is "Active"
# This adds the Conda env, Snakemake, and Apptainer to the PATH
ENV PATH="/opt/apptainer/bin:/opt/conda/envs/snake/bin:$PATH"

# Ensure the Conda env is prioritized for Python imports
ENV PYTHONPATH="/opt/conda/envs/snake/lib/python3.11/site-packages"

WORKDIR /data

# Verify installations
RUN snakemake --help && apptainer --help && snakedeploy --help
