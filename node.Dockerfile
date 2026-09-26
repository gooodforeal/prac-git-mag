FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server \
    python3 \
    sudo \
    curl \
    docker.io \
    iptables \
    ca-certificates \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/node-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 5000

CMD ["/entrypoint.sh"]
