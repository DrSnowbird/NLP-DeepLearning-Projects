#!/bin/bash -x

# ref: https://forum.rasa.com/t/using-nlu-in-docker-needs-argument-d-core/6781

container_name=rasa_core

function remove_old_rasa_core() {
    old_rasa_core=`sudo docker ps -a |grep $container_name|awk '{print $1}'`
    if [ "$old_rasa_core" != "" ]; then
        for c in $old_rasa_core; do 
            sudo docker rm  -f $c
        done
    fi
}
remove_old_rasa_core

echo "===== # Train core ====="

PROJECT_DIR=${PROJECT_DIR:-$(pwd)/projects}

## -- (mandatory) --
RASA_CORE_VERSION=latest

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

docker rm -f $(docker ps -a |grep rasa_core | awk '{print $1}')

## Note that the rasa_core (inside the container) will be running inside /app directory 
sudo docker run -it \
    -v ${PROJECT_DIR}:/app/projects \
    -v ${PROJECT_DIR}/data:/app/data \
    -v ${PROJECT_DIR}/models/core:/app/models \
    -v ${PROJECT_DIR}/config:/app/config \
    -v ${PROJECT_DIR}/logs:/app/logs \
    -v ${PROJECT_DIR}/data:/app/data \
    --name ${container_name} \
    rasa/rasa_core:latest \
        train \
        --debug_plots \
        --domain projects/domain.yml \
        --stories data/core/stories.md \
        --config config/policies.yml \
        --out models \
        --dump_stories \
        --debug \
        --verbose \
        # --url ${URL} \
        # --STORAGE ${STORAGE} \
 
echo
echo "... Remove container instance ..."
echo
remove_old_rasa_core
