# Description
A fully functioning, flexibly deployable application for visualizations of personal financial data.

---------------------------------------------------------------------

# Deployment

### Local Windows deployment using Chocolate, Docker, and Minikube:

Use a package manager and install ```docker-machine``` and ```kubectl``` and ```minikube``` and run:
```./deploy_locally_k8s.ps1```

This is a bit deprecated (for now), but you can also run via:
```docker-compose up --build -d```

#### Local Development:

Install MongoDB, NodeJS and the required NodeJS packages. Then, start a local MongoDB instance bound to port 27017. Finally, run:
```shell
node server.js --database_info 127.0.0.1:27017
```

------------------------------------------------------------------

### AWS deployment using Kops:

This is a bit deprecated, due to more interest in GKE as a deployment platform. Tweaking is needed.

Use an AWS Linux machine, clone this repo, and then run:
```cd Midas/cloud/aws && ./deploy_on_aws_k8s.sh```

-----------------------------------------------------------------

### Google Cloud Platform deployment using Google Kubernetes Engine (GKE):

Ensure billing is enabled for GCP.

#### Step 1: Spin up K8s cluster that houses the web interface and database:

Use the provided Ansible to spin up the cluster:

```shell
cd Midas/cloud/gcp/ansible/playbooks
ansible-playbook -i hosts midas.yaml --tags="midas_gke_cluster"
```

Connect to the default cluster via Google Cloud shell, then run:

```shell
git clone https://github.com/AlexDHoffer/Midas.git
cd Midas/cloud/gcp
./deploy_on_gke.sh
```

#### Step 2: Spin up Compute Engine (VM) that gathers data and publishes it to the database through the external service endpoint.

Use the provided Ansible to provision the VM:

```shell
cd Midas/cloud/gcp/ansible/playbooks
ansible-playbook -i hosts midas.yaml --tags="midas_data_vm"
```

External service endpoint portion TBD.

-------------------------------------------------------------------

### Microsoft Azure deployment:

TBD
