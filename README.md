# alphapulldown-chtc

Current tests on how to run alphapulldown (https://github.com/KosinskiLab/AlphaPulldown) on CHTC (https://chtc.cs.wisc.edu/)

Difficulties:
- Initially, I tried to create an container that has snakemake and apptainer, but the main issue was that apptainer did not have unprivileged access to all files it needed.

Current test:
- Trying to create a Dockerimage, which contains the snakemake installation and an unprivileged version of apptainer (https://apptainer.org/docs/admin/1.4/installation.html#install-unprivileged-from-pre-built-binaries).

Overall strategy:
- Build the Docker image on my laptop (Mac) (do remember to specify the build to it works on linux : `docker build --platform linux/amd64`)
- After testing that apptainer and snakemake are correctly in the container, push it to DockerHub (patriciatran111/snakemake-apptainer:V1) (note, this might change in the future)
- Log into the CHTC system and modify my .sh and .sub file
- Submit file will use the pushed docker image (patriciatran111/snakemake-apptainer:v1) in the `container_image` line
- the Sh file will container the command to run snakemake as listed in the AlphaPulldown documentation
- Check if we're still getting the unprivileged apptainer error.

