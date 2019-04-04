#!/bin/bash -x

docker run \
  -v $(pwd):/app/project \
  -v $(pwd)/models/rasa_nlu:/app/models \
  -v $(pwd)/config:/app/config \
  rasa/rasa_nlu:latest-spacy \
  run \
    python -m rasa_nlu.train \
    -c config/nlu_config.yml \
    -d project/data/nlu.md \
    -o models \
    --project current
