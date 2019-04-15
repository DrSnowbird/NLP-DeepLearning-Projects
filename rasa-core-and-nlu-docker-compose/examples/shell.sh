#!/bin/bash -x

container_id=`sudo docker ps -a |grep dockercompose_rasa_core|awk '{print $1}' `

sudo docker exec -it $container_id /bin/bash
