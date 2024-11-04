FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbullseye

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Metatrader Docker:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="gmartin"

ENV TITLE=Metatrader5
ENV WINEPREFIX="/config/.wine"

# Update package lists, upgrade packages and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    python3-pip \
    wget && \
    pip3 install --upgrade pip && \
    # Add WineHQ repository
    wget -q https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' && \
    rm winehq.key && \
    # Add i386 architecture
    dpkg --add-architecture i386 && \
    apt-get update && \
    # Install WineHQ stable
    apt-get install --install-recommends -y winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy and setup files
COPY ./mt_env /mt_env
RUN chown -R abc:abc /mt_env

COPY /Metatrader /Metatrader
COPY /root /

# Set execute permission and run start.sh
RUN chmod +x /Metatrader/start.sh

EXPOSE 3000 8001
