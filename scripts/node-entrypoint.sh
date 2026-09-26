#!/bin/bash
set -euo pipefail

mkdir -p /run/sshd /var/run

# Docker daemon внутри node1 (DinD)
dockerd \
  --host=unix:///var/run/docker.sock \
  --storage-driver=vfs \
  >/var/log/dockerd.log 2>&1 &

echo "Ждём Docker на node1..."
for _ in $(seq 1 60); do
  if docker info >/dev/null 2>&1; then
    echo "Docker на node1 готов"
    break
  fi
  sleep 1
done

if ! docker info >/dev/null 2>&1; then
  echo "Docker на node1 не поднялся:" >&2
  tail -n 50 /var/log/dockerd.log >&2 || true
  exit 1
fi

exec /usr/sbin/sshd -D
