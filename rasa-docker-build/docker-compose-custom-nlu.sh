version: '3.0'

services:

  rasa_core:
    image: rasa/rasa_core:latest
    ports:
      - 5005:5005
    volumes:
      - ./models/rasa_core:/app/models
      - ./config:/app/config
    command:
      - start
      - --core
      - models
      - -c
      - rest
      - --endpoints
      - config/endpoints.yml
      - -u
      - current/

  rasa_nlu:
    image: rasa/rasa_nlu:latest-spacy
    volumes:
      - ./models/rasa_nlu:/app/models
      - ./config:/app/config
    command:
      - start
      - --path
      - models
      - -c
      - config/nlu_config.yml

  action_server:
    image: rasa/rasa_core_sdk:latest
    volumes:
      - ./actions:/app/actions

  mongo:
    image: mongo
    environment:
      MONGO_INITDB_ROOT_USERNAME: rasa
      MONGO_INITDB_ROOT_PASSWORD: example
  mongo-express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: rasa
      ME_CONFIG_MONGODB_ADMINPASSWORD: example

