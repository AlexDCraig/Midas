#!/bin/bash
# Script for configuring credentials for CLI Azure interactions.
# Use with Ubuntu.

# Install Azure CLI and confirm who you are.
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login

# Knock two creds of the four required, and set the active subscription.
az account show --query "{subscriptionId:id, tenantId:tenantId}" > creds1.json
export ARM_SUBSCRIPTION_ID=`jq '.subscriptionId' creds1.json`
export ARM_TENANT_ID=`jq '.tenantId' creds1.json`
az account set --subscription="${ARM_SUBSCRIPTION_ID}"

# Create the Role for the app. Export the two other required creds.
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" > creds2.json
export ARM_CLIENT_ID=`jq '.appId' creds2.json`
export ARM_CLIENT_SECRET=`jq 'password' creds2.json`.

# Boilerplate.
export ARM_ENVIRONMENT=public

rm -rf creds1.json creds2.json

