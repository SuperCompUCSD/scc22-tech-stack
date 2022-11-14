#!/usr/bin/env bash 

echo "Backing up grafana data.."
sudo docker run --rm --volumes-from grafana -v $(pwd):/backup busybox tar cvf /backup/grafana.tar /var/lib/grafana

echo "Backing up prometheus data.."
sudo docker run --rm --volumes-from prometheus -v $(pwd):/backup busybox tar cvf /backup/prometheus.tar /prometheus

