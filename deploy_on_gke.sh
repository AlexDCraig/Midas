#!/bin/bash

git clone https://github.com/AlexDHoffer/Midas.git
cp credentials.json Midas/midas-data
cd Midas
export PROJECT_ID="$(gcloud config get-value project -q)"
docker build -t grc.io/${PROJECT_ID}/midas-data:v0 midas-data/
docker build -t gcr.io/${PROJECT_ID}/midas-web:v0 midas/
gcloud auth configure-docker
docker push gcr.io/${PROJECT_ID}/midas-data:v0
docker push gcr.io/${PROJECT_ID}/midas-web:v0
kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017
kubectl run midas-data --image=grc.io/${PROJECT_ID}/midas-data:v0
kubectl run midas-web --image=grc.io/${PROJECT_ID}/midas-web:v0 --port 8080
kubectl expose deployment midas-web --type=LoadBalancer --port 80 --target-port 8080

