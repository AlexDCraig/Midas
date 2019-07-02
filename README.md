# Description
Flexibly deployable visualizations of banking data.

# Deployment

### Local Windows deployment using Chocolate, Docker, and Minikube:

Use a package manager and install ```docker-machine``` and ```kubectl``` and ```minikube``` and run:
```./deploy_locally_k8s.ps1```

You can also run via:
```docker-compose up --build -d```

### AWS deployment using Kops:

This is a bit deprecated, due to more interest in GKE as a deployment platform. Tweaking is needed.

Use an AWS Linux machine, clone this repo, and then run:
```cd Midas/cloud/aws && ./deploy_on_aws_k8s.sh```

### Google Cloud Platform deployment using Google Kubernetes Engine (GKE):

Ensure billing is enabled for GCP.

#### Step 1: Spin up K8s cluster that houses the web interface and database:

Create a default cluster, connect to the default cluster via Google Cloud shell, then run:

```shell
git clone https://github.com/AlexDHoffer/Midas.git
cd Midas/cloud/gcp
./deploy_on_gke.sh
```

#### Step 2: Spin up Compute Engine (VM) that gathers data and publishes it to the database through the external service endpoint.

TBD
