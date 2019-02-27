#!/bin/bash

mkdir -p ./data
wget https://s3-us-west-2.amazonaws.com/openpolicingdata/traffic_stops_nc_2018_01_08.dump.zip -O ./data/nc.dump.zip
unzip ./data/nc.dump.zip -d ./data

docker-compose up -d
