# Kubernetes basics
kubectl = service for running commands against Kubernetes clusters

minikube = Google's solution to serving up a local Kubernetes cluster. This is a cluster consisting of 1 node allocated on localhost.

cluster = group of machines to co-ordinate work across.

A cluster consists of a master and its nodes, where master = the cluster co-ordinator, and a node = a VM that exists within the cluster.

Finally, a pod = a grouping of containers on a node. It can be only one container.

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

# Create a deployment based off the .yaml spec included in this directory.
kubectl apply -f node-server-deployment.yaml

# Expose the node-server deployment.
kubectl expose deployment node-server --type=LoadBalancer --port=8080

# Get the externally accessible URL to interface with the node server.
minikube service node-server --url

```
