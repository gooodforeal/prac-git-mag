#!/bin/bash
set -euo pipefail

# SSH-ключ Jenkins (master) → root@node1
docker exec -u jenkins master bash -lc '
  mkdir -p /var/jenkins_home/.ssh
  chmod 700 /var/jenkins_home/.ssh
  if [ ! -f /var/jenkins_home/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -N "" -f /var/jenkins_home/.ssh/id_ed25519
  fi
'

docker exec -u jenkins master cat /var/jenkins_home/.ssh/id_ed25519.pub \
  | docker exec -i node1 bash -lc '
      mkdir -p /root/.ssh
      chmod 700 /root/.ssh
      touch /root/.ssh/authorized_keys
      chmod 600 /root/.ssh/authorized_keys
      while read -r line; do
        grep -qxF "$line" /root/.ssh/authorized_keys || echo "$line" >> /root/.ssh/authorized_keys
      done
    '

docker exec -u jenkins master \
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@node1 'hostname && docker info >/dev/null && echo SSH+Docker OK'

echo "SSH master → node1 настроен"
