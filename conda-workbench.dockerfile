#Dockerfile
#Specify an ML Runtime base image
FROM docker.repository.cloudera.com/cdsw/ml-runtime-workbench-python3.9-standard:2021.09.1-b5
# Upgrade packages in the base image
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="Conda Package Manager Workbench Edition" ML_RUNTIME_SHORT_VERSION="1" ML_RUNTIME_MAINTENANCE_VERSION="1" ML_RUNTIME_FULL_VERSION="1.1" ML_RUNTIME_DESCRIPTION="This workbench runtime includes Mini-Conda"
LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION