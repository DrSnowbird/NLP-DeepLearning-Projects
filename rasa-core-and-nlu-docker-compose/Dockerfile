FROM rasa/rasa_nlu:0.14.4-full

RUN pip install rasa_core==0.13.7

COPY examples/ /app/examples/
COPY run-rasa-core.sh /app/examples/moodbot/

RUN apt-get install -y tree vim
RUN chmod +x /app/examples/moodbot/run-rasa-core.sh
