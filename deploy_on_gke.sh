#!/bin/bash

# Directions for running the Midas project on a Google Kubernetes Engine cluster.
# These directions are geared towards situations where you have shell access to a cluster.
# The only real requirement is that you need a credentials.json in the initial working directory.

cp credentials.json midas-data
export PROJECT_ID="$(gcloud config get-value project -q)"

# Build and tag the images.
docker build -t grc.io/${PROJECT_ID}/midas-data:v0 midas-data/
docker tag midas-data:v0 gcr.io/${PROJECT_ID}/midas-data:v0
docker build -t gcr.io/${PROJECT_ID}/midas-web:v0 midas/
docker tag midas-web:v0 gcr.io/${PROJECT_ID}/midas-web:v0

# Push the images to the Google registry associated with your GKE project.
gcloud auth configure-docker --quiet
docker push gcr.io/${PROJECT_ID}/midas-data:v0
docker push gcr.io/${PROJECT_ID}/midas-web:v0

kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017

# Modify the midas-data and midas-web deployment to directly refer to the images we just built, tagged, and pushed.
# Then, tell the deployment to always search for an image to pull.
python prepare_for_gke.py

kubectl apply -f deployments/midas-data-deployment.yaml
kubectl apply -f deployments/midas-web-deployment.yaml

kubectl expose deployment midas-web-deployment --type=LoadBalancer --port=80

