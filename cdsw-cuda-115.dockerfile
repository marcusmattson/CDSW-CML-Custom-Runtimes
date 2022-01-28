# Dockerfile
# Specify an ML Runtime base image - CDSW Engine 13 is based on Ubuntu 18.04
FROM docker.repository.cloudera.com/cdsw/engine:13
RUN rm /etc/apt/sources.list.d/*
# Pin file to prioritize CUDA repository
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
RUN mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
# Upgrade packages in the base image and setup repos
RUN apt-get update && apt-get install -y --no-install-recommends \
gnupg2 curl ca-certificates && \
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
apt-get purge --autoremove -y curl && \
rm -rf /var/lib/apt/lists/*
# Configure CUDA install - this can be done by hard-coding or using ENV variables
ENV CUDA_VERSION 11.5.117
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"
# Install CUDA runtime
ENV CUDA_PKG_VERSION 11-5=$CUDA_VERSION-1
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION && \
    ln -s cuda-11.5 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
    ldconfig

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
# Add NVidia and CUDA to PATH
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
# Install NVIDIA CUDA Deep Neural Network (cuDNN)
ENV CUDNN_VERSION 8.3.2.44
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn8=$CUDNN_VERSION-1+cuda11.5 && \
    apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*
