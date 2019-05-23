# Purpose
Twofold: 

a) To finally setup a nice deployment infrastructure for financial visualizations described in the previous repository ```fintech```. 

b) To get a chance to explore technologies I don't have the opportunity to daily at work (especially Windows scripting, Windows package management, NodeJS...)

# Kubernetes basics
```kubectl``` = service for running commands against Kubernetes clusters

```minikube``` = Google's solution to serving up a local Kubernetes cluster. This is a cluster consisting of 1 node allocated on localhost.

```cluster``` = group of machines to co-ordinate work across.

A ```cluster``` consists of a ```master``` and its ```node```s, where ```master``` = the ```cluster``` co-ordinator, and a ```node``` = a VM that exists within the cluster.

Finally, a ```pod``` = a grouping of containers on a node. It can be only one container.

# Sample of useful commands.

```shell
# Execute minikube:
minikube start

# Stop minikube:
minikube stop

# Delete minikube:
minikube delete

# Erase all pods:
kubectl delete pods --all
```

Windows deployment details:
- used the Chocolatey package manager to install kubectl, minikube, Docker, etc.
- docker-machine installed. Some odd errors can be resolved with a simple 'docker-machine restart'.

Useful resources:

https://rominirani.com/tutorial-getting-started-with-kubernetes-on-your-windows-laptop-with-minikube-3269b54a226

https://kubernetes.io/docs/tutorials/

https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment/

https://medium.com/@maumribeiro/running-your-own-docker-images-in-minikube-for-windows-ea7383d931f6

Code:

```shell
# Ensure minikube is running.
minikube start
minikube docker-env | Invoke-Expression

# Build Node.js image.
docker build -t node-server:v0 .

# Create two deployments, one based off the local node-server image and one based off of a remotely pulled Jenkins image.
kubectl apply -f node-server-deployment.yaml
kubectl apply -f jenkins-deployment.yaml

# Expose the node-server deployment and the Jenkins deployment.
kubectl expose deployment node-server --type=LoadBalancer --port=8080
kubectl expose deployment jenkins --type=LoadBalancer --port=8080

# Get the externally accessible URLs.
minikube service node-server --url
minikube service jenkins --url

```

Note comments in script that talk about minikube's struggle to define externally accessible IPs.

# Local deployment of nodejs server.
```shell
choco install nodejs
node server.js
# See active server at "localhost:8080" in browser of choice.
```
