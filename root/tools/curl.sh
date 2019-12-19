#!/bin/bash

if [ -z "$1" ]; then
  echo "Necesario indicar una IP";
  exit;
elif ! [ -z "$1" ]; then
  file=/srv/homeassistant/shared/nmap/$1

  # Determina el usuario de la IP
  if [ $1 = "192.168.1.15" ]; then
    name="iris"
  elif [ $1 = "192.168.1.14" ]; then
    name="josep"
  fi

  # Comprueba si existe el archivo
  if test -f "$file"; then
    num=$(cat "$file")
    if [ $num -gt "16" ]; then
      curl -d "" http://localhost:8123/api/webhook/${name}_not_home
    elif [ $num -lt "16" ]; then
      curl -d "" http://localhost:8123/api/webhook/${name}_home
    fi
  fi
fi

