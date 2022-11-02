#!/bin/sh -e
echo "Remember to run this as sudo"

sudo useradd -s /sbin/nologin --system node_exporter

# this only works for AMD64. Make param for amd/arm
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest| grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|wget -qi -

tar -xvf node_exporter*.tar.gz
cd  node_exporter*/
sudo cp node_exporter /usr/local/bin
node_exporter --version

#promp, did node exporter work?



sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF



sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
sudo systemctl enable node_exporter

curl localhost:9100/metrics
cd ../
rm -r node_exporter-*
