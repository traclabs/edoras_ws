FROM ros:jazzy-ros-base-noble AS fsw-dev

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
  build-essential \
  gdb \
  nano \
  cmake \
  git \
  pkg-config \
  sudo \
  git-lfs \
  && rm -rf /var/lib/apt/lists/*

# Switch to bash shell
SHELL ["/bin/bash", "-c"]

# Create a brash user
ENV USERNAME ubuntu
ENV CODE_DIR=/code
ENV CFS_LOCAL=cFS

# Dev container arguments
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Create new user and home directory
#RUN groupadd --gid ${USER_GID} ${USERNAME} \
#&& useradd --uid ${USER_UID} --gid ${USER_GID} --create-home ${USERNAME} \
#&& echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
#&& chmod 0440 /etc/sudoers.d/${USERNAME} \
#&& mkdir -p ${CODE_DIR} \
#&& chown -R ${USER_UID}:${USER_GID} ${CODE_DIR}

RUN echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
&& chmod 0440 /etc/sudoers.d/${USERNAME} \
&& mkdir -p ${CODE_DIR} \
&& chown -R ${USER_UID}:${USER_GID} ${CODE_DIR}

USER ${USERNAME}

# Set up sourcing
COPY --chown=${USERNAME}:${USERNAME} ./config/fsw_entrypoint.sh ${CODE_DIR}/entrypoint.sh
RUN echo 'source ${CODE_DIR}/entrypoint.sh' >> ~/.bashrc

# Set workdir
WORKDIR ${CODE_DIR}/cFS/build/exe/cpu2

##################################################
# Production
##################################################
FROM fsw-dev AS fsw

# Copy cFS
COPY --chown=${USERNAME}:${USERNAME} ${CFS_LOCAL} ${CODE_DIR}/cFS

# Build cFS
WORKDIR ${CODE_DIR}/cFS
RUN make SIMULATION=native prep && \
 make && \
 make install

# Dev environment has cFS built on mount volume
WORKDIR ${CODE_DIR}/cFS/build/exe/cpu2

