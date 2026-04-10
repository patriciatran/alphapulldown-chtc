FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. System Dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    curl \
    rpm2cpio \
    cpio \
    && rm -rf /var/lib/apt/lists/*

# 2. Generic User Setup
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

# 3. Unprivileged Apptainer Installation
RUN curl -s https://raw.githubusercontent.com/apptainer/apptainer/main/tools/install-unprivileged.sh | \
    bash -s - /home/appuser/apptainer_home

# 4. Snakemake + Compatibility Fix
RUN pip3 install --user --upgrade pip && \
    pip3 install --user pulp==2.7.0 snakemake

# 5. Environment Settings
ENV PATH="/home/appuser/.local/bin:/home/appuser/apptainer_home/bin:${PATH}"

# 6. THE FIX FOR ISSUE #2790
RUN find /home/appuser/apptainer_home -name "apptainer.conf" -exec \
    sed -i 's/^mount host localtime = yes/mount host localtime = no/' {} +

USER root
RUN touch /etc/localtime
USER appuser

CMD ["/bin/bash"]
