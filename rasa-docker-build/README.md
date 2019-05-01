# RASA Docker Pipelines

# Files Structures
The most important files
1. For Rasa Core: 
** stories.md
** domain.yml
2. For Rasa NLU: nlu.md
3. For 
```
├── curl-message-to-chatbot.sh
├── docker-compose-custom-nlu.sh
├── docker-compose.yml
├── project
│   ├── actions
│   ├── config
│   │   ├── endpoints.yml
│   │   ├── nlu-config.yml
│   │   └── policies.yml
│   ├── data
│   │   ├── core
│   │   │   └── stories.md
│   │   └── nlu
│   │       └── nlu.md
│   ├── domain.yml
│   ├── logs
│   │   ├── docker-compose.log
│   │   └── log-train-core.log
│   └── models
│       ├── core
│       │   ├── domain.json
│       │   ├── domain.yml
│       │   ├── metadata.json
│       │   ├── policy_0_KerasPolicy
│       │   │   ├── featurizer.json
│       │   │   ├── keras_model.h5
│       │   │   ├── keras_policy.json
│       │   │   └── keras_policy.tf_config.pkl
│       │   ├── policy_1_FallbackPolicy
│       │   │   └── fallback_policy.json
│       │   ├── policy_2_MemoizationPolicy
│       │   │   ├── featurizer.json
│       │   │   └── memorized_turns.json
│       │   ├── policy_3_FormPolicy
│       │   │   ├── featurizer.json
│       │   │   └── memorized_turns.json
│       │   └── stories.md
│       └── nlu
│           └── current
│               └── model_20190501-200212
├── Rasa_reference.md
├── README.md
├── test-rasa.sh
├── train-core.sh
├── train-nlu-custom-nlu.sh
└── train-nlu.sh



```
# Warning
`Due to Rasa components are actively evolving, hence, the docker images version might not work in the near future possible to due API changes for Core and NLU, etc.`

# Steps - to stand up full Rasa Docker stack components
1. Train Rasa Core first, then
2. Train Rasa NLU (you can reverse sequence with step-1 if you like)
3. Deploy the Rasa stack using `docker-compose up`
4. Test Rasa docker stack using REST api (with curl) to say hello to Rasa chat server.

# Configuration 
* For MongoDB connection IP in config/endpoints.yml, you need to change to your actual IP address of the MongoDB container to work!
  (To be improved later to allow localhost connection)
  
# Training Core
```
```

# Training NLU
```
```

# Start Full RASA Stack and Pipelines
```
docker-compose up
```

# Test Rasa Stack and Pipeline with trained Core and NLU models
```
(Send Hello to Rasa (Core) Server at localhost:5005 port)
./curl-message-to-chatbot.sh 
+ curl --request POST --url http://localhost:5005/webhooks/rest/webhook --header 'content-type: application/json' --data '{
    "message": "hello"
  }'

(REST API call response)
[
  {
    "recipient_id": "default",
    "text": "Hi, how is it going?"
  }
]
```

# References
* [Using Rasa NLU with Docker - The easiest way to get started working with Rasa](https://blog.spg.ai/using-rasa-nlu-with-docker-96b86856b392)
* [Rasa Docker how to](https://rasa.com/docs/core/docker_walkthrough/)
* [rasa/rasa_nlu - Docker Hub](https://hub.docker.com/r/rasa/rasa_nlu/)
* [Docs on how to build a bot with rasa & docker](


