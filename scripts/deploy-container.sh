#!/usr/bin/env bash
set -euo pipefail

image="devops-lab1-app:${BUILD_NUMBER:-local}"
container=rishav-lab1-deployed
docker build -f docker/Dockerfile -t "$image" .
docker rm -f "$container" >/dev/null 2>&1 || true
docker run -d --name "$container" --label devops.lab=1 \
    -p 127.0.0.1:5011:5000 "$image"

for attempt in $(seq 1 30); do
    if docker exec "$container" python -c \
        "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2).read().decode())"; then
        echo "Container deployment passed the health check on port 5011."
        exit 0
    fi
    sleep 1
done
echo "Container deployment did not become healthy." >&2
exit 1
