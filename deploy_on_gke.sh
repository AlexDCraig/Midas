#!/bin/bash

# Directions for running the Midas project on a Google Kubernetes Engine cluster.
# These directions are geared towards situations where you have shell access to a cluster.
# The only real requirement is that you need a credentials.json in the initial working directory.

git clone https://github.com/AlexDHoffer/Midas.git
cp credentials.json Midas/midas-data
cd Midas
export PROJECT_ID="$(gcloud config get-value project -q)"

# Build and tag the images.
docker build -t grc.io/${PROJECT_ID}/midas-data:v0 midas-data/
docker build -t gcr.io/${PROJECT_ID}/midas-web:v0 midas/

# Push the images to the Google registry associated with your GKE project.
gcloud auth configure-docker
docker push gcr.io/${PROJECT_ID}/midas-data:v0
docker push gcr.io/${PROJECT_ID}/midas-web:v0

kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017

# Modify the midas-data deployment by modifying ImagePullPolicy to be "Always". And, set the image in there to exactly match the one that pops up
# when you run "docker images". Something like this: gcr.io/midas-244222/midas-data:v0
kubectl apply -f deployments/midas-data-deployment

# Do the same modifications for the midas-web deployment. Then:
kubectl apply -f deployments/midas-web-deployment

kubectl expose deployment midas-web-deployment --type=LoadBalancer --port=80

