# syntax=docker/dockerfile:1.3-labs

# See this documentation for the explanation of the tag
# https://www.ros.org/reps/rep-0142.html#desktop-variants
FROM osrf/ros:jazzy-desktop-full

# Disable prompt interactions so the script runs alone without user input.
ARG DEBIAN_FRONTEND=noninteractive

# Install ROS2.
# Since it's slow, and should not be changed frequently, it should stay at the
# start of the file.
RUN <<EOF
    apt-get update -y

    # Installing ROS2 necessary tooling.
    apt-get -y install --no-install-recommends \
        ros-${ROS_DISTRO}-desktop \
        ros-dev-tools \
        python3-pip

    # Install stlink tools for STM32 board reset.
    apt-get -y install --no-install-recommends stlink-tools

    # Installing other useful ROS2 packages.
    apt-get -y install --no-install-recommends \
        ros-jazzy-rqt-tf-trees

    # Installing gazebo and necessary tools.
    curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list >/dev/null
    apt-get update -y
    apt-get -y install --no-install-recommends \
        ros-${ROS_DISTRO}-ros-gz \
        gz-harmonic
EOF

# Configure environment variables

# This is required for detection of which version of gazebo will be used.
ENV GZ_VERSION="harmonic"
# Set the domain ID to the same value as the one used in our embedded firmware.
ENV ROS_DOMAIN_ID=25

# Configuring for access via SSH, this is only needed if accessing the
# container without VSCode.
RUN <<EOF
    apt-get install -y --no-install-recommends \
        openssh-server \
        xauth
    mkdir /var/run/sshd
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config # Allow for X11 forwarding
    echo "AddressFamily inet" >> /etc/ssh/sshd_config # Docker does not really like ipv6, so do not allow it in the daemon
EOF

EXPOSE 22

# Random Dev tools
RUN <<EOF
apt-get install -y --no-install-recommends \
    fish \
    fzf \
    htop \
    less \
    python3-venv \
    stow \
    tmux \
    x11-apps \
    zsh
EOF

# Commands that require variables environment files should be last

# Add user with sudo capabilities
ARG DOCKER_USER=amr

# Perhaps, using the same UID as the host might be a good idea, it will avoid
# possible conflicts in the future.
RUN <<EOF
    deluser --remove-home ubuntu # The osrf Image has the default user: ubuntu
    apt-get -y install --no-install-recommends \
        sudo
    useradd -m -g sudo ${DOCKER_USER}
    echo "${DOCKER_USER}:${DOCKER_USER}" | chpasswd
    chown ${DOCKER_USER} /home/${DOCKER_USER}
    cp -a /etc/skel/. /home/${DOCKER_USER}
EOF

RUN <<EOF
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${DOCKER_USER}/.bashrc
EOF

# This will be overridden in the compose file, its only here if you want to use
# raw Dockerfile.

# For a interactive session
RUN chsh -s /bin/bash ${DOCKER_USER}
USER ${DOCKER_USER}
CMD ["/bin/bash"]

# For a ssh session
# USER root
# CMD ["/usr/sbin/sshd", "-D"]
