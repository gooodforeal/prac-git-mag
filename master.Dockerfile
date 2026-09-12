FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    ssh \
    python3 \
    git \
    iputils-ping \
    && mkdir -p /ansible \
    && rm -rf /var/lib/apt/lists/*

RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    pipeline-stage-view

USER jenkins
WORKDIR /ansible
