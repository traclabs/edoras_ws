FROM osrf/ros:humble-desktop AS fsw-dev

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN  apt update && apt install -y \
  build-essential \
  gdb \
  nano \
  cmake \
  git \
  pkg-config \
  ros-humble-ros-ign-gazebo \
  ros-humble-gazebo-ros-pkgs \
  ros-humble-ros-gz \
  libnlopt-dev \
  libnlopt-cxx-dev \
  ros-humble-urdf \
  ros-humble-kdl-parser \
  ros-humble-xacro \
  ros-humble-joint-state-publisher \
  ros-humble-joint-state-publisher-gui \
  ros-humble-rviz2 \
  ros-humble-robot-localization \
  ros-humble-ign-ros2-control \
  ros-humble-ros2controlcli \
  ros-humble-joint-trajectory-controller \
  ros-humble-joint-state-broadcaster \
  && rm -rf /var/lib/apt/lists/*

# Switch to bash shell
SHELL ["/bin/bash", "-c"]

# Create a brash user
ENV USERNAME=traclabs
ENV CODE_DIR=/code
ENV CFS_LOCAL=cFS

# Dev container arguments
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Create new user and home directory
RUN groupadd --gid ${USER_GID} ${USERNAME} \
&& useradd --uid ${USER_UID} --gid ${USER_GID} --create-home ${USERNAME} \
&& echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
&& chmod 0440 /etc/sudoers.d/${USERNAME} \
&& mkdir -p ${CODE_DIR} \
&& chown -R ${USER_UID}:${USER_GID} ${CODE_DIR}

#RUN echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
#&& chmod 0440 /etc/sudoers.d/${USERNAME} \
#&& mkdir -p ${CODE_DIR} \
#&& chown -R ${USER_UID}:${USER_GID} ${CODE_DIR}


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

