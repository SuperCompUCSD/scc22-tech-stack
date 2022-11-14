#!/usr/bin/env bash 

echo "loading grafana backup.tar into container.."
sudo docker run --rm --volumes-from grafana -v $(pwd):/backup busybox tar xvf /backup/grafana.tar -C /

echo "loading prometheus backup.tar into container.."
sudo docker run --rm --volumes-from prometheus -v $(pwd):/backup busybox tar xvf /backup/prometheus.tar -C /prometheus

