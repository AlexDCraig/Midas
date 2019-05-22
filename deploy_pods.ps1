# Ensure minikube is running.
minikube start
minikube docker-env | Invoke-Expression

kubectl delete --all pods

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
