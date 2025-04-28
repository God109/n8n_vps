#!/bin/bash

# Docker Installation
echo "🚀 Starting Docker installation..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
echo "✅ Docker installation completed!"

# Creating n8n Data Volume
echo "📂 Creating n8n data volume and temp directory..."
cd ~
mkdir -p n8n_data n8n_temp
sudo chown -R 1000:1000 n8n_data n8n_temp
sudo chmod -R 755 n8n_data n8n_temp
echo "✅ n8n data volume and temp directory are ready!"

# Docker Compose and Dockerfile Setup
echo "🛠️ Setting up Docker Compose and Dockerfile..."

# Download compose.yaml
wget https://raw.githubusercontent.com/God109/n8n_vps/refs/heads/main/compose.yaml -O compose.yaml

# Create Dockerfile
cat <<EOF > Dockerfile
FROM n8nio/n8n

USER root

RUN apt-get update && apt-get install -y ffmpeg python3-pip \\
    && pip3 install yt-dlp telethon \\
    && apt-get clean

USER node
EOF

# Run Docker Compose
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
sudo -E docker compose up -d --build
echo "🎉 Installation complete! Access your service at: \$EXTERNAL_IP"
