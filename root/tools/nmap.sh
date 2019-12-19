#!/bin/bash
# Comprueba durante 1 minuto si una IP está activa en la red
# indicandolo en el archivo $file, sumando 1 por cada fallo
# y reseteando la cuenta cuando lo encuentra. (Hecho para Android) 

file=/srv/homeassistant/shared/nmap/$1

# Comprueba si se ha introducido valor
if [ -z "$1" ]; then
  echo "Necesario indicar una IP";
  exit;
elif ! [ -z "$1" ]; then
  ip=$1
  # Comprueba si existe el archivo, sino lo crea y inicializa
  if test -f "$file"; then
    num=$(cat "$file")
  else
    num=0
    cat <<< "$num" > $file
  fi

  for i in {1..11}
  do
    nmap=$( nmap $ip -sn | grep Host | awk '{print $1}')
    if [ $nmap = "Host" ]; then
      echo 0 > $file
    else
      let "num+=1"
      echo $num > $file
    fi
    num=$(cat "$file")
    sleep 5
  done

fi

