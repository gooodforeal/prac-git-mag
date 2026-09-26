#!/bin/bash
set -euo pipefail

IMAGE="${IMAGE:-todo-app:latest}"
CONTAINER="${CONTAINER:-todo-app}"

cd "$(dirname "$0")/.."

sudo docker build -t "$IMAGE" -t todo-app:latest .
ansible-playbook -i inventory.ini deploy.yml -e "image=${IMAGE} container_name=${CONTAINER}"

echo "Приложение на node1: http://localhost:8082"
