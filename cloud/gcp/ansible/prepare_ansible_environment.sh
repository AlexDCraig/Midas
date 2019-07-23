#!/bin/bash

xargs sudo yum -y install < yum-requirements.txt
sudo pip install -r requirements.txt

# Run the playbook.
# ansible-playbook -i hosts midas.yaml

# Run only the VM provisioner.
# ansible-playbook -i hosts midas.yaml --tags="midas_data_vm"

# Run only the Kubernetes cluster provisioner.
# ansible-playbook -i hosts midas.yaml --tags="midas_gke_cluster"

