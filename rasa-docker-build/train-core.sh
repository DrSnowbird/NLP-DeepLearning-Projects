#!/bin/bash -x

# ref: https://forum.rasa.com/t/using-nlu-in-docker-needs-argument-d-core/6781

container_name=rasa_core

function remove_old_rasa_core() {
    old_rasa_core=`sudo docker ps -a |grep $container_name|awk '{print $1}'`
    if [ $old_rasa_core ]; then
        sudo docker rm  -f $old_rasa_core
    fi
}
#remove_old_rasa_core

echo "===== # Train core ====="
PROJECT_DIR=${PROJECT_DIR:-$(pwd)/project}

## -- (mandatory) --

RASA_CORE_VERSION=latest
DOMAIN=/app/domain.yml

## directory to persist the trained model in
OUT=/app/models

## Policy specification yaml file
POLICY_CONFIG=/app/config/policies.yml

## -- (optional) --

## File or folder containing stories
STORIES=/data/core/stories.md

## If supplied, downloads a story file from a URL and
## trains on it. Fetches the data by sending a GET
## request to the supplied URL
#URL="<URL to download a story file>"

## Note that the rasa_core (inside the container) will be running inside /app directory 
sudo docker run -it \
    -v ${PROJECT_DIR}:/app/project \
    -v ${PROJECT_DIR}/models/core:/app/models \
    -v ${PROJECT_DIR}/config:/app/config \
    --name ${container_name} \
    rasa/rasa_core:latest \
        train --debug_plots --domain domain.yml --stories data/core/stories.md --config config/policies.yml --out models --endpoints config/endpoints.yml
            
            # --url ${URL} \
            # --STORAGE ${STORAGE} \
            # --dump_stories \
            # --debug \
            # --verbose \

