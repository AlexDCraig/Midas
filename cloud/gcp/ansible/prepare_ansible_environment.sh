#!/bin/bash

xargs sudo yum -y install < yum-requirements.txt
sudo pip install -r requirements.txt

# Run a playbook.
# ansible-playbook -i hosts midas.yaml

