## -- rasa_core.train "default" --
python -m rasa_core.train default \
    --debug_plots \
    --domain ./domain.yml \
    --stories ./data/core/stories.md \
    --out ./models/dialogue

## -- rasa_nlu.train "default" --
python -m rasa_nlu.train \
    --config ./nlu_model_config.json \
    --data ./data/nlu \
    --fixed_model_name current

## -- rasa_core.train "compare" --
#python -m rasa_core.train compare --debug_plots --stories ./data/core/stories.md --domain ./domain.yml --out models/dialogue --runs 300

## -- rasa_core.train "interactive" --
#python -m rasa_core.train interactive --debug_plots --nlu ./models/nlu/default/current --stories ./data/core/stories.md --domain ./domain.yml --out models/dialogue

## -- rasa_core.run "enable_api" --
#    --auth_token thisismysecret \
python -m rasa_core.run \
    --enable_api \
    --core ./models/dialogue \
    --nlu ./models/nlu/default/current \
    --endpoints ./config/endpoints.yaml \
    --cors '*' \
    -o out.log
