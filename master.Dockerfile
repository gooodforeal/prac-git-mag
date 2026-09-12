FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    ssh \
    python3 \
    git \
    curl \
    iputils-ping \
    docker.io \
    sudo \
    && mkdir -p /ansible \
    && echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*

RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    pipeline-stage-view

USER jenkins
WORKDIR /ansible
