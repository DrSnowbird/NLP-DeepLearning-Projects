#!/bin/bash -x

# -----------------------------------------------------------------------------
# ref: https://forum.rasa.com/t/using-nlu-in-docker-needs-argument-d-core/6781
# Compiled information from Rasa web site
# -----------------------------------------------------------------------------

echo "===== # Train NLU ====="

HOST_DIR=${HOST_DIR:-$(pwd)}

RASA_NLU_VERSION=latest-spacy
container_name=rasa_nlu

## -- (mandatory) --
PROJECT=current
PATH=model

## -- (optional) --
NUM_THREADS=2

## If present, a model will always be persisted in the
## specified directory instead of creating a folder like 'model_20171020-160213'
FIXED_MODEL_NAME=current

#NLU_ENDPOINTS="<EndpointConfig defining the server from which pull training data>"

## URL from which to retrieve training data.
#URL="<from which to retrieve training data>"

## STORAGE  Set the remote location where models are stored. 
## E.g. on AWS. If nothing is configured, 
## the server will only serve the models that are on disk in the configured `--path`.
#STORAGE="<some remote storage path>"

## Note that the rasa_nlu (inside the container) will be running inside /app directory 
sudo docker run \
    -v ${HOST_DIR}:/app/project \
    -v ${HOST_DIR}/models/nlu:/app/models \
    -v ${HOST_DIR}/config:/app/config \
    --name ${container_name} \
    rasa/rasa_nlu:${RASA_NLU_VERSION} \
        run \
            python -m rasa_nlu.train \
            --config ./config/nlu_config.yml \
            --data ./project/data/nlu \
            --path ./models \
            --num_threads ${NUM_THREADS:-2} \
            # --fixed_model_name ${FIXED_MODEL_NAME} \
            # --url ${URL} \
            # --endpoints ${NLU_ENDPOINTS} \
            # --STORAGE ${STORAGE} \
            # --debug \
            # --verbose \
            --project ${PROJECT} \

