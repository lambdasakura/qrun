FROM ubuntu:latest
# setup Amazon Q CLI
RUN apt-get update && apt-get install -y wget libayatana-appindicator3-1 \
                                              libwebkit2gtk-4.1-0 \
                                              libgtk-3-0

RUN wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb && \
    apt-get update && apt-get install -f && dpkg -i amazon-q.deb && rm amazon-q.deb

# Install Packages you need
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo \
        apt-utils \
        openssh-client \
        gnupg2 \
        dirmngr \
        iproute2 \
        procps \
        lsof \
        htop \
        net-tools \
        psmisc \
        curl \
        wget \
        rsync \
        ca-certificates \
        unzip \
        zip \
        nano \
        vim-tiny \
        less \
        jq \
        apt-transport-https \
        zlib1g \
        locales \
        sudo \
        ncdu \
        man-db \
        strace \
        manpages \
        manpages-dev \
        curl git vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG USER_UID=1000       
ARG USER_GID=1000
ARG USER_NAME=ubuntu

RUN set -eux; \
    if ! getent group "${USER_GID}" >/dev/null; then \
        groupadd --gid "${USER_GID}" "${USER_NAME}"; \
    fi; \
    if ! getent passwd "${USER_UID}" >/dev/null; then \
        useradd  --uid  "${USER_UID}" \
                 --gid  "${USER_GID}" \
                 --create-home \
                 --shell /bin/bash \
                 "${USER_NAME}"; \
    fi; \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_NAME}"; \
    chmod 0440 "/etc/sudoers.d/${USER_NAME}"

WORKDIR /workspace

USER dev
CMD ["bash"]
