# Deploy the application and corresponding Jenkins back-end to a local Kubernetes cluster (minikube) on Windows.

docker-machine restart
minikube delete

# Ensure minikube is running.
minikube start
minikube docker-env | Invoke-Expression

kubectl delete --all pods

# Build Node.js image and back-end data processing Python scripts image.
docker build -t midas-web:v0 midas/
docker build -t midas-data:v0 midas-data/

# Create two deployments, one based off the local node-server image and one based off of a remotely pulled Jenkins image.
kubectl apply -f midas-web-deployment.yaml
kubectl apply -f jenkins-deployment.yaml

# Expose the node-server deployment and the Jenkins deployment.
# We want NodePort type. LoadBalancer is a type native to cloud services.
kubectl expose deployment midas-web-deployment --type=NodePort --port=80
kubectl expose deployment jenkins --type=NodePort --port=81

# Get the externally accessible (to your own network) URLs.
minikube service midas-web-deployment --url
minikube service jenkins --url

# Access the url in your browser by taking the exact url given from the command above and appending the filename to it (e.g. /home.html).

# Expose to the outside world through the VirtualBox VM using an ingress.
# Use with caution.
# https://github.com/nginxinc/kubernetes-ingress/issues/158 has a good template for what this should look like
# kubectl apply -f midas-web-ingress.yml
# ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L \*:30000:0.0.0.0:30000
# Load in browser: minikube ip, then copy paste that plus target port into browser
