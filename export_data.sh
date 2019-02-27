#!/bin/bash

set -e

docker-compose up -d
docker-compose exec database bash -c '
               psql \
               -U "$POSTGRES_USER" \
               -c "\copy (SELECT * FROM analysis_view) TO /data/traffic_stops_nc.csv WITH CSV HEADER;"
'
xz data/traffic_stops_nc.csv --stdout > traffic_stops_nc.csv.xz
