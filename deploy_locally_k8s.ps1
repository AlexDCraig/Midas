# Deploy each component of the application as a Kubernetes deployment, using Windows tools.

docker-machine restart
minikube delete

# Ensure minikube is running.
minikube start
minikube docker-env | Invoke-Expression

kubectl delete --all pods

# Build Node.js image and back-end data processing Python scripts image.
docker build -t midas-web:v0 midas/
docker build -t midas-data:v0 midas-data/

# Apply the mongodb deployment and create a service for it before the others.
# We want it to be first so that the other deployments can access it immediately.
# We can access mongodb from within a pod by using 'mongo midas-mongo-deployment:27017'. Of course, the pod must have mongodb installed on it.
kubectl apply -f deployments/midas-mongo-deployment.yaml
kubectl expose deployment midas-mongo-deployment --type=NodePort --port=27017

# We want our midas-data deployment to be next, so it can have a little extra time to populate the database for our web service to use.
kubectl apply -f deployments/midas-data-deployment.yaml

# We're applying deployments for our front-end web UI, back-end Jenkins server, and a pod that will strictly handle our data processing.
kubectl apply -f deployments/midas-web-deployment.yaml
kubectl apply -f deployments/jenkins-deployment.yaml

# Expose the node-server deployment and the Jenkins deployment.
# We want NodePort type. LoadBalancer is a type native to cloud services.
kubectl expose deployment midas-web-deployment --type=NodePort --port=80
kubectl expose deployment jenkins --type=NodePort --port=8080

# Get the externally accessible (to your own network) URLs.
minikube service midas-web-deployment --url
minikube service jenkins --url

# Access the midas url in your browser by taking the exact url/port combo given from the command above and appending the filename to it (e.g. /home.html).
# Acces the Jenkins url in your browser by just taking the exact url/port combo.

# Expose to the outside world through the VirtualBox VM using an ingress.
# Use with caution.
# https://github.com/nginxinc/kubernetes-ingress/issues/158 has a good template for what this should look like
# kubectl apply -f ingress/midas-web-ingress.yml
# ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L \*:30000:0.0.0.0:30000
# Load in browser: minikube ip, then copy paste that plus target port into browser
