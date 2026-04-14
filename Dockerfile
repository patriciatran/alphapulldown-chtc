FROM --platform=linux/amd64 python:3.11-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    rpm2cpio \
    cpio \
    wget \
    git \
    libfuse2 \
    squashfs-tools \
    && rm -rf /var/lib/apt/lists/*

# Install Apptainer (Unprivileged)
RUN mkdir -p /opt/apptainer && \
    curl -s https://raw.githubusercontent.com/apptainer/apptainer/main/tools/install-unprivileged.sh | \
    bash -s - /opt/apptainer

# Add Apptainer to the PATH
ENV PATH="/opt/apptainer/bin:${PATH}"

# Install Snakemake
RUN pip install --no-cache-dir snakemake

WORKDIR /data
CMD ["snakemake", "--version"]
