FROM ubuntu18
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ARG VITIS_VER
ARG VITIS_MAIN
ARG IP
ARG URIS=smb://${IP}/Share/Vitis${VITIS_VER}/
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
          binutils \
          u-boot-tools \
          file \
          tofrodos \
          iproute2 \
          net-tools \
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
          pkg-config \
          ocl-icd-opencl-dev \
          smbclient \
          notification-daemon \
          chromium-browser \
          libjpeg62-dev && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install \
          zlib1g:i386 \
          libc6-dev:i386 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
  useradd -s /bin/bash -u ${USER_ID} -o -m -d ${HOME} ${USER} && \
  echo root:root |chpasswd && \
  echo ${USER}:${USER} |chpasswd && \
  usermod -aG sudo ${USER} && \
  chown ${USER_ID}:${GROUP_ID} -R ${HOME} && \
  chown ${USER_ID}:${GROUP_ID} -R /opt && \
  chown ${USER_ID}:${GROUP_ID} -R /VITIS-INSTALLER
USER $USER
RUN smbget -O -a ${URIS}${VITIS_MAIN} | gzip -dcq - | tar x --strip-components=1 -C /VITIS-INSTALLER && \
  /VITIS-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VITIS-INSTALLER/install_config_main.txt
USER root
RUN rm -rf /VITIS-INSTALLER /home/builduser
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

