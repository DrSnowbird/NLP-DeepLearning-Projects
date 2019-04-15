# rasa-core-and-nlu-docker-compose
Rasa core and rasa nlu enviroment for local enviroment with moodbot example from official [Rasa Stack documentation](http://rasa.com/)


## Setup for Rasa Stack on local enviroment


### Clone project:
```
git clone https://github.com/sasastarcevic/rasa-core-and-nlu-docker-compose.git
```

### Go to project
```
cd rasa-core-and-nlu-docker-compose
```

### Build docker-compose file
```
docker-compose build
```
Note: First time it can take 5-10 min!


### Run docker-compose
```
docker-compose up -d
```

### Check status of Rasa Stack container
```
docker ps -as
```

### Rasa Stack container status
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                            NAMES                  SIZE
40ba123eecdb        rasacore_rasa_core   "./entrypoint.sh s..."   9 seconds ago       Up 8 seconds        0.0.0.0:5000->5000/tcp, 0.0.0.0:5005->5005/tcp   rasacore_rasa_core_1   525 kB (virtual 2.7 GB)
```
Where ports are used by two RASA components, NLU and CORE
* 0.0.0.0:5000: NLU: eg., 
    curl 0.0.0.0:5000 --> hello from Rasa NLU: 0.14.4
* 0.0.0.0:5005: CORE: e.g.,
    curl 0.0.0.0:5005 --> hello from Rasa Core: 0.13.7

### Attach to rasa_core container
```
docker exec -it 40ba123eecdb bash
```

### Go to folder:
```
cd examples/moodbot/
```
And, you actually run those scripts below:
```
## -- rasa_nlu.train "default" --
python -m rasa_nlu.train \
    -d ./data/nlu \
    --config ./nlu_model_config.json \
    --fixed_model_name current

## -- rasa_core.train "default" --
python -m rasa_core.train default \
    --debug_plots \
    --stories ./data/core/stories.md \
    --domain ./domain.yml \
    --out ./models/dialogue

## -- rasa_core.train "compare" --
#python -m rasa_core.train compare --debug_plots --stories ./data/core/stories.md --domain ./domain.yml --out models/dialogue --runs 300

## -- rasa_core.train "interactive" --
#python -m rasa_core.train interactive --debug_plots --nlu ./models/nlu/default/current --stories ./data/core/stories.md --domain ./domain.yml --out models/dialogue

## -- rasa_core.run "enable_api" --
python -m rasa_core.run \
    --enable_api \
    #--auth_token thisismysecret \
    --core ./models/dialogue \
    --nlu ./models/nlu/default/current \
#    --endpoints ./config/endpoints.yaml \
    --cors '*' \
    -o out.log
```

### Execute run-rasa-server.sh script and wait until Rasa Core server is started
See also [Rasa Running the HTTP server](https://rasa.com/docs/core/server/#)
```
./run-rasa-core.sh
```

### Rasa Core server started sucessfully
```
Using TensorFlow backend.
2018-04-18 21:13:33+0000 [-] Log opened.
2018-04-18 21:13:33+0000 [-] Site starting on 5005
2018-04-18 21:13:33+0000 [-] Starting factory <twisted.web.server.Site object at 0x7fcca0c0abe0>
```

## Check '''Rasa NLU''' Rest API
```
curl 'http://localhost:5000/parse?q=hello'
> Response:
{
  "intent": {
    "name": "greet",
    "confidence": 1.0
  },
  "entities": [],
  "text": "hello",
  "project": "default",
  "model": "fallback"
}
```
Note: [Official Rasa Nlu documentation](https://nlu.rasa.com/http.html)

## Check '''Rasa Core''' Rest API
```
curl -XPOST localhost:5005/conversations/default/parse -d '{"query":"hello there"}'
curl -XPOST localhost:5005/webhooks/rest/webhook -d '{"message": "hello"}'
# The REST API of Rasa Core is then available on http://localhost:5005. To send messages to your chatbot:
curl --request POST \
  --url http://localhost:5005/webhooks/rest/webhook \
  --header 'content-type: application/json' \
  --data '{
    "message": "hello"
  }'
curl -XGET localhost:5005/conversations/default/tracker?token=thisismysecret
{"active_form":{},"events":[{"confidence":null,"event":"action","name":"action_listen","policy":null,"timestamp":1555171366.262591},{"event":"user","input_channel":"rest","parse_data":{"entities":[],"intent":{"confidence":0.6678912709715871,"name":"greet"},"intent_ranking":[{"confidence":0.6678912709715871,"name":"greet"},{"confidence":0.2626576315898199,"name":"goodbye"},{"confidence":0.033688882264159496,"name":"mood_great"},{"confidence":0.02300475937613501,"name":"mood_affirm"},{"confidence":0.008187574550468575,"name":"mood_unhappy"},{"confidence":0.004569881247829675,"name":"mood_deny"}],"text":"hello"},"text":"hello","timestamp":1555171366.2896032},{"confidence":1.0,"event":"action","name":"utter_greet","policy":"policy_2_MemoizationPolicy","timestamp":1555171366.448173},{"data":{"attachment":null,"buttons":[{"payload":"great","title":"great"},{"payload":"super sad","title":"super sad"}],"elements":null},"event":"bot","text":"Hey! How are you?","timestamp":1555171366.4481833},{"confidence":1.0,"event":"action","name":"action_listen","policy":"policy_2_MemoizationPolicy","timestamp":1555171366.452795}],"followup_action":null,"latest_action_name":"action_listen","latest_event_time":1555171366.452795,"latest_input_channel":"rest","latest_message":{"entities":[],"intent":{"confidence":0.6678912709715871,"name":"greet"},"intent_ranking":[{"confidence":0.6678912709715871,"name":"greet"},{"confidence":0.2626576315898199,"name":"goodbye"},{"confidence":0.033688882264159496,"name":"mood_great"},{"confidence":0.02300475937613501,"name":"mood_affirm"},{"confidence":0.008187574550468575,"name":"mood_unhappy"},{"confidence":0.004569881247829675,"name":"mood_deny"}],"text":"hello"},"paused":false,"sender_id":"default","slots":{}}

```
Note: [Official Rasa Core documentation](https://core.rasa.com/http.html)

# Fetching Rasa Core Models From a Server
You can also configure the http server to fetch models from another URL:
```
$ python -m rasa_core.run \
    --enable_api \
    -d ./models/dialogue \
    -u ./models/nlu/current \
    --endpoints ./config/endpoints.yaml \
    -o out.log
```
# Reference

## Usage: rasa.nlu_train
```
usage: train.py [-h] [-o PATH] (-d DATA | -u URL | --endpoints ENDPOINTS) -c
                CONFIG [-t NUM_THREADS] [--project PROJECT]
                [--fixed_model_name FIXED_MODEL_NAME] [--storage STORAGE]
                [--debug] [-v]

train a custom language parser

optional arguments:
  -h, --help            show this help message and exit
  -o PATH, --path PATH  Path where model files will be saved
  -d DATA, --data DATA  Location of the training data. For JSON and markdown
                        data, this can either be a single file or a directory
                        containing multiple training data files.
  -u URL, --url URL     URL from which to retrieve training data.
  --endpoints ENDPOINTS
                        EndpointConfig defining the server from which pull
                        training data.
  -c CONFIG, --config CONFIG
                        Rasa NLU configuration file
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads to use during model training
  --project PROJECT     Project this model belongs to.
  --fixed_model_name FIXED_MODEL_NAME
                        If present, a model will always be persisted in the
                        specified directory instead of creating a folder like
                        'model_20171020-160213'
  --storage STORAGE     Set the remote location where models are stored. E.g.
                        on AWS. If nothing is configured, the server will only
                        serve the models that are on disk in the configured
                        `path`.
  --debug               Print lots of debugging statements. Sets logging level
                        to DEBUG
  -v, --verbose         Be verbose. Sets logging level to INFO

```

## Usage: rasa_core.train 
```
root@f7c40c91750d:/app/examples/moodbot# python -m rasa_core.train -h
usage: train.py [-h] {default,compare,interactive} ...

Train a dialogue model for Rasa Core. The training will use your conversations
in the story training data format and your domain definition to train a
dialogue model to predict a bots actions.

positional arguments:
  {default,compare,interactive}
                        Training mode of core.
    default             train a dialogue model
    compare             train multiple dialogue models to compare policies
    interactive         teach the bot with interactive learning

optional arguments:
  -h, --help            show this help message and exit

root@f7c40c91750d:/app/examples/moodbot# python -m rasa_core.train default -h
usage: train.py default [-h] [--augmentation AUGMENTATION] [--dump_stories]
                        [--debug_plots] [-v] [-vv] [--quiet] [-c CONFIG] -o
                        OUT (-s STORIES | --url URL) -d DOMAIN

optional arguments:
  -h, --help            show this help message and exit
  --augmentation AUGMENTATION
                        how much data augmentation to use during training
  --dump_stories        If enabled, save flattened stories to a file
  --debug_plots         If enabled, will create plots showing checkpoints and
                        their connections between story blocks in a file
                        called `story_blocks_connections.html`.
  -v, --verbose         Be verbose. Sets logging level to INFO
  -vv, --debug          Print lots of debugging statements. Sets logging level
                        to DEBUG
  --quiet               Be quiet! Sets logging level to WARNING
  -c CONFIG, --config CONFIG
                        Policy specification yaml file.
  -o OUT, --out OUT     directory to persist the trained model in
  -s STORIES, --stories STORIES
                        File or folder containing stories
  --url URL             If supplied, downloads a story file from a URL and
                        trains on it. Fetches the data by sending a GET
                        request to the supplied URL.
  -d DOMAIN, --domain DOMAIN
                        Domain specification (yml file)
root@f7c40c91750d:/app/examples/moodbot# python -m rasa_core.train compare -h
usage: train.py compare [-h] [--augmentation AUGMENTATION] [--dump_stories]
                        [--debug_plots] [-v] [-vv] [--quiet]
                        [--percentages [PERCENTAGES [PERCENTAGES ...]]]
                        [--runs RUNS] -o OUT [-c [CONFIG [CONFIG ...]]]
                        (-s STORIES | --url URL) -d DOMAIN

optional arguments:
  -h, --help            show this help message and exit
  --augmentation AUGMENTATION
                        how much data augmentation to use during training
  --dump_stories        If enabled, save flattened stories to a file
  --debug_plots         If enabled, will create plots showing checkpoints and
                        their connections between story blocks in a file
                        called `story_blocks_connections.html`.
  -v, --verbose         Be verbose. Sets logging level to INFO
  -vv, --debug          Print lots of debugging statements. Sets logging level
                        to DEBUG
  --quiet               Be quiet! Sets logging level to WARNING
  --percentages [PERCENTAGES [PERCENTAGES ...]]
                        Range of exclusion percentages
  --runs RUNS           Number of runs for experiments
  -o OUT, --out OUT     directory to persist the trained model in
  -c [CONFIG [CONFIG ...]], --config [CONFIG [CONFIG ...]]
                        Policy specification yaml file.
  -s STORIES, --stories STORIES
                        File or folder containing stories
  --url URL             If supplied, downloads a story file from a URL and
                        trains on it. Fetches the data by sending a GET
                        request to the supplied URL.
  -d DOMAIN, --domain DOMAIN
                        Domain specification (yml file)
root@f7c40c91750d:/app/examples/moodbot# python -m rasa_core.train interactive -h
usage: train.py interactive [-h] [--augmentation AUGMENTATION]
                            [--dump_stories] [--debug_plots] [-v] [-vv]
                            [--quiet] [-u NLU] [--endpoints ENDPOINTS]
                            [--skip_visualization] [--finetune] [-o OUT]
                            [-c CONFIG] (-s STORIES | --url URL | --core CORE)
                            [-d DOMAIN]

optional arguments:
  -h, --help            show this help message and exit
  --augmentation AUGMENTATION
                        how much data augmentation to use during training
  --dump_stories        If enabled, save flattened stories to a file
  --debug_plots         If enabled, will create plots showing checkpoints and
                        their connections between story blocks in a file
                        called `story_blocks_connections.html`.
  -v, --verbose         Be verbose. Sets logging level to INFO
  -vv, --debug          Print lots of debugging statements. Sets logging level
                        to DEBUG
  --quiet               Be quiet! Sets logging level to WARNING
  -u NLU, --nlu NLU     trained nlu model
  --endpoints ENDPOINTS
                        Configuration file for the connectors as a yml file
  --skip_visualization  disables plotting the visualization during interactive
                        learning
  --finetune            retrain the model immediately based on feedback.
  -o OUT, --out OUT     directory to persist the trained model in
  -c CONFIG, --config CONFIG
                        Policy specification yaml file.
  -s STORIES, --stories STORIES
                        File or folder containing stories
  --url URL             If supplied, downloads a story file from a URL and
                        trains on it. Fetches the data by sending a GET
                        request to the supplied URL.
  --core CORE           Path to a pre-trained core model directory
  -d DOMAIN, --domain DOMAIN
                        Domain specification (yml file)

```
## Usage: rasa_core.server (deprecated - not supported using rasa_core.run instead) 
```
root@f7c40c91750d:/app/examples/moodbot# python -m rasa_core.run -h
usage: run.py [-h] -d CORE [-u NLU] [-p PORT] [--auth_token AUTH_TOKEN]
              [--cors [CORS [CORS ...]]] [-o LOG_FILE]
              [--credentials CREDENTIALS] [--endpoints ENDPOINTS]
              [-c CONNECTOR] [--enable_api] [--jwt_secret JWT_SECRET]
              [--jwt_method JWT_METHOD] [-v] [-vv] [--quiet]

starts the bot

optional arguments:
  -h, --help            show this help message and exit
  -d CORE, --core CORE  core model to run
  -u NLU, --nlu NLU     nlu model to run
  -p PORT, --port PORT  port to run the server at
  --auth_token AUTH_TOKEN
                        Enable token based authentication. Requests need to
                        provide the token to be accepted.
  --cors [CORS [CORS ...]]
                        enable CORS for the passed origin. Use * to whitelist
                        all origins
  -o LOG_FILE, --log_file LOG_FILE
                        store log file in specified file
  --credentials CREDENTIALS
                        authentication credentials for the connector as a yml
                        file
  --endpoints ENDPOINTS
                        Configuration file for the connectors as a yml file
  -c CONNECTOR, --connector CONNECTOR
                        service to connect to
  --enable_api          Start the web server api in addition to the input
                        channel
  -v, --verbose         Be verbose. Sets logging level to INFO
  -vv, --debug          Print lots of debugging statements. Sets logging level
                        to DEBUG
  --quiet               Be quiet! Sets logging level to WARNING

JWT Authentication:
  --jwt_secret JWT_SECRET
                        Public key for asymmetric JWT methods or shared
                        secretfor symmetric methods. Please also make sure to
                        use --jwt_method to select the method of the
                        signature, otherwise this argument will be ignored.
  --jwt_method JWT_METHOD
                        Method used for the signature of the JWT
                        authentication payload.
```



