#!/bin/bash
set -euo pipefail

IMAGE="${IMAGE:-todo-app:latest}"
CONTAINER="${CONTAINER:-todo-app}"

sudo docker build -t "$IMAGE" -t todo-app:latest .
sudo docker rm -f "$CONTAINER" 2>/dev/null || true
sudo docker run -d \
  --name "$CONTAINER" \
  --network ansible-net \
  -p 8082:5000 \
  -v todo_data:/data \
  --restart unless-stopped \
  "$IMAGE"

echo "Приложение: http://localhost:8082"
