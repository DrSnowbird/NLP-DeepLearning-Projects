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


