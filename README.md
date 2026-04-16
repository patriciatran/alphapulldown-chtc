# alphapulldown-chtc

Current tests on how to run alphapulldown (https://github.com/KosinskiLab/AlphaPulldown) on CHTC (https://chtc.cs.wisc.edu/)

**Difficulties**:
- Initially, I tried to create an container that has snakemake and apptainer, but the main issue was that apptainer did not have unprivileged access to all files it needed.

**Completed**:
- Created a Docker container that has a snakemake install and an unprivileged version of apptainer (https://apptainer.org/docs/admin/1.4/installation.html#install-unprivileged-from-pre-built-binaries).
- The current version is pushed on docker sub under `docker://patriciatran111/snakemake-apptainer:14APRIL2026_V2`

**Overall strategy**:
- Build the Docker image on my laptop (Mac) (do remember to specify the build to it works on linux:
```
docker buildx build --platform linux/amd64 -t snakemake-apptainer:latest --load .
```
- After testing that container, tag + push it to dockerhub.

- Log into the CHTC system and modify my .sh and .sub file to point to updated containers.

- Submit file:
    - will use the pushed docker image in the `container_image` line (preferred)
    - use a Docker image converted to Apptainer image

- Sh file will container the command to run snakemake as listed in the AlphaPulldown documentation
    - Important to include extra options: 
    ```
    snakemake --profile config/profiles/desktop \
	--cores 8 \
	--use-singularity \
	--singularity-args "--unsquash --pid --ipc"
    ```

- Identify any errors in the snakemake run command

**Current issue**:

Trying to figure out why Apptainer executes properly on its own, but not when "initiated" by snakemake.