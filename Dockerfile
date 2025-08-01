# Use Ubuntu 20.04 LTS as base image for better IO2D compatibility
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    wget \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install C++ compiler and build tools (GCC 9 for IO2D compatibility)
RUN apt-get update && apt-get install -y \
    gcc-9 \
    g++-9 \
    make \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# Set GCC 9 as default (better compatibility with IO2D)
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-9 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-9

# Install Cairo and graphics libraries
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libgraphicsmagick1-dev \
    libgraphicsmagick++1-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    libtiff-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxrender-dev \
    libx11-dev \
    libxext-dev \
    libxft-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxfixes-dev \
    libxrandr-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional development libraries (using compatible versions for IO2D)
RUN apt-get update && apt-get install -y \
    libboost1.71-all-dev \
    libeigen3-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libtool \
    autoconf \
    automake \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /usr/src/app

# Install IO2D library with compatibility fixes
RUN git clone --recurse-submodules https://github.com/cpp-io2d/P0267_RefImpl /tmp/io2d && \
    cd /tmp/io2d && \
    # Apply compatibility fixes for modern compilers
    sed -i 's/CMAKE_CXX_STANDARD 17/CMAKE_CXX_STANDARD 14/' CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_CXX_STANDARD=14 \
             -DIO2D_WITHOUT_SAMPLES=ON \
             -DIO2D_WITHOUT_TESTS=ON && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/io2d

# Copy the project files
COPY . .

# Create build directory and configure build environment
RUN mkdir -p build

# Set working directory to the project root
WORKDIR /usr/src/app

# Set the default command to show build instructions
CMD ["bash", "-c", "echo 'Container ready! To build the project:' && echo 'cd build && cmake .. && make' && echo 'To run: ./OSM_A_star_search' && /bin/bash"]
