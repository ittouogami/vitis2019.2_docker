FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ENV VITIS_VER=2019.2
ARG URIS=smb://192.168.0.217/Share/Vitis2019.2/
ARG VITIS_MAIN=Xilinx_Vitis_2019.2_1024_1831.tar.gz
ENV USER=${USER:-builduser}
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}
ENV HOME=/home/$USER
COPY install_config_main.txt /VITIS-INSTALLER/
RUN \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install sudo && \
  apt-get -y -qq --no-install-recommends install \
          locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq --no-install-recommends install \
          software-properties-common \
          build-essential \
          binutils \
          ncurses-dev \
          u-boot-tools \
          file tofrodos \
          iproute2 \
          gawk \
          net-tools \
          libncurses5-dev \
          tftp \
          tftpd-hpa \
          zlib1g-dev \
          libssl-dev \
          flex \
          bison \
          libselinux1 \
          diffstat \
          xvfb \
          chrpath \
          xterm \
          libtool \
          socat \
          autoconf \
          unzip \
          texinfo \
          gcc-multilib \
          libsdl1.2-dev \
          libglib2.0-dev \
          libtool-bin \
          cpio \
          python \
          python3 \
          pkg-config \
          git \
          ocl-icd-opencl-dev \
          libjpeg62-dev && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install \
          zlib1g:i386 \
          libc6-dev:i386 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
  useradd -s /bin/bash -u $USER_ID -o -m -d $HOME $USER && \
  echo root:root |chpasswd && \
  echo ${USER}:${USER} |chpasswd && \
  usermod -aG sudo $USER && \
  chown $USER_ID:$GROUP_ID -R $HOME && \
  chown $USER_ID:$GROUP_ID -R /opt && \
  chown $USER_ID:$GROUP_ID -R /VITIS-INSTALLER
USER $USER
RUN curl -u guest ${URIS}${VITIS_MAIN} | tar zx --strip-components=1 -C /VITIS-INSTALLER && \
  /VITIS-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VITIS-INSTALLER/install_config_main.txt
USER root
RUN rm -rf /VITIS-INSTALLER /home/builduser
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-c", "source /opt/Xilinx/Vitis/${VITIS_VER}/settings64.sh;source /opt/Xilinx/Vivado/${VITIS_VER}/settings64.sh;/bin/bash -l"]
