################################################
# Build ros-base                               #
# (ROS2 image with default packages)           #
################################################
FROM osrf/ros:jazzy-desktop AS ros-base
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
# Needed for OpenGL fix for Rviz to display
# && apt-get install -y software-properties-common \
# && add-apt-repository -y ppa:kisak/kisak-mesa \ 
 && apt update \ 
 && apt -y upgrade \
 && apt-get install -y \
  python3-pip \ 
  libnlopt-dev \
  libnlopt-cxx-dev \
# Note: ros-jazzy-desktop is needed for ARM base image, but is already available for nominal -desktop image
  ros-jazzy-desktop \
  ros-jazzy-xacro \
  ros-jazzy-joint-state-publisher \
  ros-jazzy-srdfdom \
  ros-jazzy-rqt* \
  ros-jazzy-ament-cmake-test \
 && rm -rf /var/lib/apt/lists/*

RUN pip install cfdp --break-system-packages

# Switch to bash shell
SHELL ["/bin/bash", "-c"]

# Create a brash user
ENV USERNAME=ubuntu
ENV CODE_DIR=/code

# Dev container arguments
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN  echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
&& chmod 0440 /etc/sudoers.d/${USERNAME} \
&& mkdir -p ${CODE_DIR} \
&& chown -R ${USER_UID}:${USER_GID} ${CODE_DIR}


USER ${USERNAME}
WORKDIR ${CODE_DIR}

################################################
# Build rosgsw-dev                             #
################################################

FROM ros-base AS rosgsw-dev
ENV DEBIAN_FRONTEND=noninteractive

RUN sudo apt-get update && sudo apt-get install -y \
  libnlopt-dev \
  libnlopt-cxx-dev \
  ros-jazzy-xacro \
  ros-jazzy-joint-state-publisher \
  ros-jazzy-srdfdom \
  ros-jazzy-joint-state-publisher-gui \
  ros-jazzy-geometric-shapes \
  ros-jazzy-rqt-robot-steering \
  ros-jazzy-rqt* \
  ros-jazzy-topic-tools \  
  libdwarf-dev \
  libelf-dev \
  libsqlite3-dev \
  sqlitebrowser \
 && sudo rm -rf /var/lib/apt/lists/*

# Set up sourcing
COPY --chown=${USERNAME}:${USERNAME} config/rosgsw_entrypoint.sh ${CODE_DIR}/entrypoint.sh
RUN echo 'source ${CODE_DIR}/entrypoint.sh' >> ~/.bashrc


RUN mkdir -p ${CODE_DIR}/edoras
WORKDIR ${CODE_DIR}/edoras

################################################
# Build rosfsw-dev                             #
################################################

FROM rosgsw-dev AS rosfsw-dev
ENV DEBIAN_FRONTEND=noninteractive

RUN sudo apt-get update && sudo apt-get install -y \
  ros-jazzy-controller-interface \
  ros-jazzy-realtime-tools \
  ros-jazzy-control-toolbox \
  ros-jazzy-geometric-shapes \
  ros-jazzy-controller-manager \
  ros-jazzy-joint-trajectory-controller \
  ros-jazzy-rqt* \
#  ignition-fortress \
  ros-jazzy-ros-gz-sim \
  ros-jazzy-ros-gz-bridge \
  ros-jazzy-robot-localization \
  ros-jazzy-interactive-marker-twist-server \
  ros-jazzy-twist-mux \
  ros-jazzy-joy-linux \
  ros-jazzy-imu-tools \
  ros-jazzy-topic-tools \
#  ros-jazzy-ign-ros2-control \
  ros-jazzy-joint-state-broadcaster \
  ros-jazzy-diff-drive-controller \
#  ros-jazzy-clearpath-gz \
 && sudo rm -rf /var/lib/apt/lists/*

WORKDIR ${CODE_DIR}/edoras


##################################################
# Build rosgsw (Production)
##################################################
#FROM rosgsw-dev AS rosgsw

# Copy brash=
#COPY --chown=${USERNAME}:${USERNAME} brash ${CODE_DIR}/brash

# Build the brash workspace
#WORKDIR ${CODE_DIR}/brash
#RUN source /opt/ros/jazzy/setup.bash &&  \
#    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# Build juicer
#COPY --chown=${USERNAME}:${USERNAME} juicer ${CODE_DIR}/juicer
#WORKDIR ${CODE_DIR}/juicer
#RUN  make

# Set workspace
#WORKDIR ${CODE_DIR}/brash



##################################################
# Build rosfsw (Production)
##################################################
#FROM rosfsw-dev AS rosfsw

# Copy brash
#COPY --chown=${USERNAME}:${USERNAME} brash ${CODE_DIR}/brash

# Build the brash workspace
#WORKDIR ${CODE_DIR}/brash
#RUN source ${CODE_DIR}/rover_ws/install/setup.bash && \
#    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# Build juicer
#COPY --chown=${USERNAME}:${USERNAME} juicer ${CODE_DIR}/juicer
#WORKDIR ${CODE_DIR}/juicer
#RUN  make

# Set workspace
#WORKDIR ${CODE_DIR}/brash

