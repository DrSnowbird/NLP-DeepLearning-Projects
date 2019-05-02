#!/bin/bash -x

container_name=rasa_nlu

function remove_old_rasa_nlu() {
    old_rasa_nlu=`sudo docker ps -a |grep $container_name|awk '{print $1}'`
    if [ "$old_rasa_nlu" != "" ]; then
	for c in $old_rasa_nlu; do 
            sudo docker rm  -f $c
        done
    fi
}
remove_old_rasa_nlu

echo "===== Train rasa nlu ====="

PROJECT_DIR=${PROJECT_DIR:-$(pwd)/projects}

RASA_NLU_VERSION=latest-spacy

## -- (optional) --
NUM_THREADS=2

## If supplied, downloads a story file from a URL and
## trains on it. Fetches the data by sending a GET
## request to the supplied URL
#URL="<URL to download a story file>"

## Note that the rasa_nlu (inside the container) will be running inside /app directory 
sudo docker run -it \
    -v ${PROJECT_DIR}:/app/projects \
    -v ${PROJECT_DIR}/models/nlu:/app/models \
    -v ${PROJECT_DIR}/config:/app/config \
    -v ${PROJECT_DIR}/logs:/app/logs \
    -v ${PROJECT_DIR}/data:/app/data \
    --name ${container_name} \
    rasa/rasa_nlu:${RASA_NLU_VERSION} \
    run \
        python -m rasa_nlu.train \
        --fixed_model_name nlu_model \
        --config config/nlu-config.yml \
        --data projects/data/nlu/nlu.md \
        --path models \
        --num_threads ${NUM_THREADS:-2} \
        --verbose
        
echo
echo "... Remove container instance ..."
echo
remove_old_rasa_nlu
