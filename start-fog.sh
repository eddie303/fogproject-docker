#!/bin/sh

## start docker-fog 

FOG_DIR="/srv/fog"

SERVER_IP="10.0.66.2"
FOG_DIR=/srv/fog

docker run -d \
-p $SERVER_IP:212:212/udp \
-p $SERVER_IP:9098:9098 \
-p $SERVER_IP:21:21 \
-p $SERVER_IP:80:80 \
-p $SERVER_IP:69:69/udp \
-p $SERVER_IP:8099:8099 \
-p $SERVER_IP:2049:2049 \
-p $SERVER_IP:2049:2049/udp \
-p $SERVER_IP:111:111/udp \
-p $SERVER_IP:4045:4045/udp \
-p $SERVER_IP:4045:4045 \
-p $SERVER_IP:111:111 \
-p $SERVER_IP:34463:34463/udp \
-p $SERVER_IP:34463:34463 \
-e DB_NAME="fog" \
-e DB_USER="fogusr" \
-e DB_PASS="f0gp455t4" \
--link apia-mariadb:db \
--cap-add=ALL --privileged -e WEB_HOST_PORT=80 --name=fog \
-v $FOG_DIR:/transfer -v $FOG_DIR/opt:/opt/fog -v $FOG_DIR/images:/images eddie303/fogproject-docker

