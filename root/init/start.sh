#!/bin/bash
COMPOSE="/usr/bin/docker-compose"
DC_FILE="/root/init/docker-compose.yml"
DOCKER="/usr/bin/docker"

help="How to use it: ./start.sh [OPTION]\n\nOPTIONS:\n"
help+="  <empty>\tStarts docker-compose.yaml configuration\n"
help+="  pull\t\tDownload last images from docker-compose.yaml\n"
help+="  prune\t\tRemoves unused images\n"
help+="  force\t\tPull and Prune options at same time\n"
help+="  restart\tRestart all dockers\n"
help+="  recreate\tRecreate all dockers"

# EXECUTE WITHOUT COMMANDS
if [ -z "$1" ]; then
  $COMPOSE -f $DC_FILE up -d

# EJECUTA COMANDOS
elif ! [ -z "$1" ]; then
  pull=0; prune=0; restart=0; recreate=0;
  if [ "$1" == "pull" ];    then pull=1;
	elif [ "$1" == "prune" ]; then prune=1;
	elif [ "$1" == "force" ]; then pull=1; prune=1;
	elif [ "$1" == "restart" ]; then restart=1;
  elif [ "$1" == "recreate" ]; then recreate=1;
	# HELP / ERROR
	elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then echo -e $help; exit;
  else
    echo -e "Unknown command\n"$help
	fi

	# UPDATES IMAGES FROM COMPOSE
	if [ $pull != 0 ]; then
    for image in $(grep "image:" $DC_FILE | grep -v "#" | awk '{print $2}' > /dev/null 2>&1)
	  do
	    $DOCKER pull $image
	  done
	  $COMPOSE -f $DC_FILE up -d
	fi
	# DELETES UNUSED IMAGES
	if [ $prune != 0 ]; then
	  $DOCKER image prune -f -a
	fi
	# RESTART ALL DOCKERS
	if [ $restart != 0 ]; then
    for image in $(grep '^  \w' $DC_FILE | sed 's/.$//')
    do
      $DOCKER restart $image
    done
  fi
  # RECREATE ALL DOCKERS
	if [ $recreate != 0 ]; then
    line=`grep -n "services:" docker-compose.yml | awk -F":" '{print $1}'`
    for image in $(cat $DC_FILE | awk '{if (NR>='$line') print}' | grep '^  \w' | sed 's/.$//')
    #grep '^  \w' $DC_FILE | sed 's/.$//'| grep -v "internal")
    do
      echo "Stopping $image..."
      $DOCKER stop $image > /dev/null 2>&1
      echo "Removing $image..."
      $DOCKER rm $image > /dev/null 2>&1
    done
    $COMPOSE -f $DC_FILE up -d
  fi
fi
