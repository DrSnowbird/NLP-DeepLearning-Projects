#!/bin/bash -x

# The REST API of Rasa Core is then available on http://localhost:5005. To send messages to your chatbot:

curl --request POST \
  --url http://localhost:5005/webhooks/rest/webhook \
  --header 'content-type: application/json' \
  --data '{
    "message": "hello"
  }'
