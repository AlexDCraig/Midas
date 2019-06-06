# Description
Flexibly deployable visualizations of banking data.

# Deployment
Directions for Windows deployment:

Use a package manager and install ```docker-machine``` and ```kubectl``` and ```minikube``` and run:
```./deploy_locally_k8s.ps1```

You can also run via:
```docker-compose up --build -d```

Directions for AWS deployment:

Use an AWS Linux machine and run:
```./deploy_on_aws_k8s.sh```
