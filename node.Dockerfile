FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server \
    python3 \
    sudo \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 22 80

CMD ["/usr/sbin/sshd", "-D"]
