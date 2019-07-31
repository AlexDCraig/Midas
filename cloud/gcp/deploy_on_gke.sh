#!/bin/bash

# Directions for running the Midas project on a Google Kubernetes Engine cluster.
# These directions are geared towards situations where you have shell access to a cluster.

# Pull down Istio files and deploy Istio in preparation for sidecar injection.
# Download istio.
ORIG_PATH=$PWD
CLONED_MIDAS=$PWD/Midas
ISTIO_DIR=`find ${ORIG_PATH} -name 'istio-*' | head -n 1`

if [ -d "$ISTIO_DIR" ]; then
    rm -rf "$ISTIO_DIR"
fi

if [ -d "$CLONED_MIDAS" ]; then
    rm -rf "$CLONED_MIDAS"
fi

curl -L https://git.io/getLatestIstio | sh -
ISTIO_DIR=`find ${ORIG_PATH} -name 'istio-*' | head -n 1`
cd ${ISTIO_DIR}
export PATH=$PWD/bin:$PATH

# Apply the istio deployment.
kubectl apply -f install/kubernetes/istio-demo-auth.yaml

git clone https://github.com/AlexDHoffer/Midas.git
cd Midas && git checkout dev/istio

# Pull down the web app from Alex's Docker Hub.
docker pull alexdchoffer/midas-web:v0

# Configure the database.
kubectl apply -f <(istioctl kube-inject -f deployments/midas-mongo-deployment.yaml)
kubectl expose deployment midas-mongo-deployment --type=LoadBalancer --port=27017

# Modify the midas-web deployment to directly refer to the image we just built, tagged, and pushed.
# Then, tell the deployment to always search for an image to pull.
python cloud/gcp/prepare_for_gke.py ${ISTIO_DIR}

kubectl apply -f <(istioctl kube-inject -f deployments/midas-web-deployment.yaml)
kubectl expose deployment midas-web-deployment --type=LoadBalancer --port=80

kubectl apply -f midas-gateway.yaml
kubectl apply -f midas-home-policy.yaml

# SSH into data VM: gcloud compute ssh crdhost --command ...
# Run script in data VM (midas-data-deployment) that publishes data to midas-mongo service.
