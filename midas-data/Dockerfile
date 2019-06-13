FROM python:3.8.0b1-alpine3.9
RUN apk add --update \
    git \
    mongodb \
  && rm -rf /var/cache/apk/*
RUN git clone https://github.com/AlexDHoffer/fintech.git /midas-data
WORKDIR /midas-data/email_handler
COPY credentials.json .
RUN pip install -r requirements.txt
ENTRYPOINT ["python", "emails.py", "Alex's Checking", "midas-mongo-deployment:27017"]
