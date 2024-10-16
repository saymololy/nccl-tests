FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

ARG CONDA_VERSION

WORKDIR /workspace

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get remove -y --allow-change-held-packages \
    ibverbs-utils \
    libibverbs-dev \
    libibverbs1 \
    libmlx5-1 \
    libnccl2 \
    libnccl-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    apt-utils \
    autoconf \
    automake \
    build-essential \
    check \
    cmake \
    curl \
    debhelper \
    devscripts \
    git \
    gcc \
    gdb \
    kmod \
    libsubunit-dev \
    libtool \
    openmpi-bin \
    libopenmpi-dev \
    openssh-client \
    openssh-server \
    pkg-config \
    python3-distutils \
    vim \
    net-tools

# RUN git clone https://github.com/NVIDIA/nccl-tests.git && \
#     cd nccl-tests && \
#     make MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi

RUN git clone https://github.com/NVIDIA/nccl-tests.git /opt/nccl-tests \
    cd nccl-tests && \
    && make -j $(nproc) \
    MPI=1 \
    MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi \
    CUDA_HOME=/usr/local/cuda \
    NCCL_HOME=/opt/nccl/build \
    NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80 -gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_89,code=sm_89 -gencode=arch=compute_90,code=sm_90"
