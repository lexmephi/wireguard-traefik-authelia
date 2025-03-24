#!/bin/bash

while getopts "r:u:p:" opt; do
  case $opt in
    r) RELEASE="$OPTARG";;
    u) USERNAME="$OPTARG";;
    p) PASSWORD="$OPTARG";;
    *) echo "Использование: $0 [-r release] [-u username] [-p password]" >&2
       exit 1
  esac
done

apt install yq -y

curl -L -o wireguard-traefik-authelia-${RELEASE}.zip https://github.com/lexmephi/wireguard-traefik-authelia/archive/refs/tags/${RELEASE}.zip

unzip wireguard-traefik-authelia-${RELEASE}.zip

cd wireguard-traefik-authelia-${RELEASE}/config

DIGEST=$(docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'YOUR_PASSWORD')
echo $DIGEST
hash=$(echo -n "$DIGEST" | cut -d' ' -f2)

echo -n $hash
OLD_USER="default"

sed -i "s/^  $OLD_USER:/  $USERNAME:/" users_database.yml

yq ".users.${USERNAME}.password = \"${hash}\"" users_database.yml
