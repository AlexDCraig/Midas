#!/bin/bash

# Directions for running the Midas project on a Google Kubernetes Engine cluster.
# These directions are geared towards situations where you have shell access to a cluster.

git clone https://github.com/AlexDHoffer/Midas.git
cd Midas

# Pull down the web app from Alex's Docker Hub.
docker pull alexdchoffer/midas-web:v0

# Configure the database.
kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017

kubectl apply -f deployments/midas-web-deployment.yaml
kubectl expose deployment midas-web-deployment --type=LoadBalancer --port=80

# Modify the midas-web deployment to directly refer to the image we just built, tagged, and pushed.
# Then, tell the deployment to always search for an image to pull.
python cloud/gcp/prepare_for_gke.py

# SSH into data VM: gcloud compute ssh crdhost --command ...
# Run script in data VM (midas-data-deployment) that publishes data to midas-mongo service.
