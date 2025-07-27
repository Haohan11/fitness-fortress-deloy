#!/bin/bash

# 一旦腳本中有任何指令失敗（exit code ≠ 0），整個腳本就會立刻停止執行。
set -e

# 取得 GCP VM 外部 IP
EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip")

if [ -z "$EXTERNAL_IP" ]; then
  echo "❌ 無法取得 External IP。確認此腳本在 GCP VM 上執行。"
  exit 1
fi

# 顯示取得的 IP
echo "🛰️  Detected external IP: $EXTERNAL_IP"

echo "🔁 Rebuilding and restarting containers..."
EXTERNAL_IP=$EXTERNAL_IP docker-compose up -d --force-recreate

# echo "✅ Deploy completed!"
