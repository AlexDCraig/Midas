# Description
Flexibly deployable visualizations of banking data.

# Deployment
Directions for Windows deployment:

Use a package manager and install ```docker-machine``` and ```kubectl``` and ```minikube``` and run:
```./deploy_locally_k8s.ps1```

You can also run via:
```docker-compose up --build -d```

Directions for AWS deployment:

Use an AWS Linux machine, clone this repo, and then run:
```./deploy_on_aws_k8s.sh```

Directions for Google Kubernetes Engine (GKE) deployment:

Ensure billing is enabled for GKE, create a default cluster, connect to the default cluster via Google Cloud shell, then:
```git clone https://github.com/AlexDHoffer/Midas.git```
```cd Midas```
```# Make sure you've got a credentials.json file for the Gmail API in the current working directory.``` 
```./deploy_on_gke.sh```
