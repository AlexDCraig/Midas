# Description
Flexibly deployable visualizations of banking data.

# Deployment

### Local Windows deployment using Chocolate, Docker, and Minikube:

Use a package manager and install ```docker-machine``` and ```kubectl``` and ```minikube``` and run:
```./deploy_locally_k8s.ps1```

You can also run via:
```docker-compose up --build -d```

### AWS deployment using Kops:

Use an AWS Linux machine, clone this repo, and then run:
```./deploy_on_aws_k8s.sh```

### Google Cloud Platform deployment using Google Kubernetes Engine (GKE):

Ensure billing is enabled for GKE, create a default cluster, connect to the default cluster via Google Cloud shell, then:

```shell
git clone https://github.com/AlexDHoffer/Midas.git
cd Midas
# Make sure you've got a credentials.json file for the Gmail API in the current working directory. 
./deploy_on_gke.sh```
