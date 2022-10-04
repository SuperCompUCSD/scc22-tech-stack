#!/bin/sh -e
cargo build -r
sudo cp -i target/release/high-temp-auto-shutdown /usr/local/bin/
sudo chmod 700 /usr/local/bin/high-temp-auto-shutdown
cat high-temp-auto-shutdown.service | sudo tee /etc/systemd/system/high-temp-auto-shutdown.service
sudo systemctl daemon-reload
sudo systemctl enable --now high-temp-auto-shutdown.service
sudo systemctl status high-temp-auto-shutdown.service
