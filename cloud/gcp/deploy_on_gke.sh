#!/bin/bash

# Directions for running the Midas project on a Google Kubernetes Engine cluster.
# These directions are geared towards situations where you have shell access to a cluster.

git clone https://github.com/AlexDHoffer/Midas.git
cd Midas

# Build and tag the web interface..
docker pull alexdchoffer/midas-web:v0

# Configure the database.
kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017

kubectl apply -f deployments/midas-web-deployment.yaml
kubectl expose deployment midas-web-deployment --type=LoadBalancer --port=80

# SSH into data VM: gcloud compute ssh crdhost --command ...
# Run script in data VM (midas-data-deployment) that publishes data to midas-mongo service.
