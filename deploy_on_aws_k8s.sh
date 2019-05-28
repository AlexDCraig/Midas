#!/bin/bash

# Deploy application using Kubernetes on AWS. This route requires 2 CPUs each node, thus it is not possible to do this without racking up cost (e.g. non-eligible for free tier).
# This deployment does not use Amazon's managed Kubernetes cluster product EKS.

# IAM user needs these roles: AmazonEC2FullAccess, AmazonRoute53FullAccess, AmazonS3FullAccess, IAMFullAccess, AmazonVPCFullAccess
# Helpful notes: https://medium.com/containermind/how-to-create-a-kubernetes-cluster-on-aws-in-few-minutes-89dda10354f4

# Install various packages.
sudo yum install -y git pip docker kubectl kubeadm kubelet
git clone https://github.com/AlexDHoffer/kubernetes-investigation.git

# Install, configure AWS CLI.
pip install awscli --upgrade --user
export AWS_ACCESS_KEY_ID=[]
export AWS_SECRET_ACCESS_KEY=[]
aws configure

# Set the AWS stage for kops. Create bucket. Set versioning.
# aws s3api create-bucket --bucket alexdch-kops-bucket --region us-east-1
# aws s3api put-bucket-versioning --bucket alexdch-kops-bucket --versioning-configuration Status=Enabled

# Install, configure kops.
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/17449887 | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux*
sudo mv kops-linux-amd64 /usr/local/bin/kops
export KOPS_CLUSTER_NAME=alexdc.k8s.local
export KOPS_STATE_STORE=s3://aws-alexdch-kops-bucket
ssh-keygen
kops create secret --name alexdc.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub

# Create and deploy k8s cluster.
kops create cluster --node-count=1 --node-size=t2.micro --zones=us-east-1a --name=alexdc.k8s.local
kops update cluster --name alexdc.k8s.local --yes

# Apply Kubernetes deployments.
cd kubernetes-investigation
kubectl apply -f node-server-deployment.yaml
kubectl apply -f jenkins-deployment.yaml

