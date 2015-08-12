#
# OpenSim Dockerfile v1.0
# Source code can be found at https://github.com/opensim-org/opensim-core
#

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Thomas Lau

# Install OpenSim Dependencies
RUN apt-get update && apt-get install -y \
  cmake\
  g++-4.8 \
  git \
  build-essential \
  liblapack-dev

# Install Simbody
RUN git clone https://github.com/simbody/simbody.git ~/simbody-source && \
    mkdir ~/simbody-build && \
    cd simbody-build && \
    cmake ~/simbody-source -DBUILD_BINARY_DIR=~/simbody-build -DCMAKE_INSTALL_PREFIX=~/simbody-install -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_VISUALIZER=off && \
    make -j8 install

# Install OpenSim
RUN git clone https://github.com/opensim-org/opensim-core.git ~/opensim-core-source

RUN mkdir ~/opensim-core-source-build && \
    cd opensim-core-source-build && \
    cmake ~/opensim-core-source -DSIMBODY_HOME=/simbody-build/simbody-install && \
    pwd && \
    ls && \
    make -j8 install

# Define working directory.
WORKDIR ~/opensim-core-source

# Define default command.
CMD ["bash"]