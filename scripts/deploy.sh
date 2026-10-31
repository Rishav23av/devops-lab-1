#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Run this script with sudo on the Ubuntu deployment host." >&2
    exit 1
fi

source_dir="${1:?Usage: deploy-lab1 /absolute/path/to/repository}"
target_dir=/opt/rishav-devops-lab1
test -f "$source_dir/app/requirements.txt"
install -d -m 0755 "$target_dir/app"
cp "$source_dir/app/app.py" "$source_dir/app/__init__.py" \
   "$source_dir/app/requirements.txt" "$target_dir/app/"
python3 -m venv "$target_dir/.venv"
"$target_dir/.venv/bin/python" -m pip install -r "$target_dir/app/requirements.txt"
systemctl restart devops-lab1.service

for attempt in $(seq 1 20); do
    if curl --fail --silent --max-time 2 http://127.0.0.1:5001/health; then
        echo
        echo "Deployment passed the health check."
        exit 0
    fi
    sleep 1
done

echo "The app did not become healthy. Check journalctl -u devops-lab1." >&2
exit 1
