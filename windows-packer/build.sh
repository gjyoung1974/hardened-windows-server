#!/bin/bash

# Source the Google Cloud SDK:
source /root/project/google-cloud-sdk/completion.bash.inc
source /root/project/google-cloud-sdk/path.bash.inc

# Enable packer logging
PACKER_LOG=1

# get the local .\Administrator account secret
ADMIN_PASSWORD=$(echo -n "$ADMIN_PWD_CIPHERTEXT" | base64 -d | gcloud kms decrypt \
  --ciphertext-file=- \
  --plaintext-file=- \
  --key=$SECRETS_KEY \
  --keyring=$SECRETS_KEYRING \
  --location=global
)

# Scope the WinRM firewall rule to the caller's IPV4 address
echo "Getting our Public IPV4 address"
MY_PUBLIC_IPV4=$(curl https://api.ipify.org)

#Set the Packer host project
PROJECT_ID=$GOOGLE_PROJECT_ID
NETWORK_ID="projects/$GOOGLE_PROJECT_ID/global/networks/$GCP_NETWORK_ID"
GCP_SUBNETWORK=$GCP_SUBNET_ID

# Temporarily enable WinRM traffic
gcloud compute firewall-rules create allow-winrm --allow tcp:5986 --source-ranges "$MY_PUBLIC_IPV4/32" --network $NETWORK_ID

# Select a source image from google's GCE compute image repository:
SOURCE_IMAGE="windows-server-2019-dc-v20190620" # Server 2019 Datacenter Edition 06-20-2019 release
IMAGE_FAMILY="windows-server-2019-dc"

# Set the alternate local administrator account
ALT_ADMIN_USER="s0meUsr"

# Variables for Packer Script
export ALT_ADMIN_USER
export ADMIN_PASSWORD
export PROJECT_ID
export NETWORK_ID
export GCP_SUBNETWORK
export SOURCE_IMAGE
export IMAGE_FAMILY

# Build a Windows Server image
packer build ./windows-packer/gcp_hardened_windows_server.json

# Remove WinRM firewall rule
yes | gcloud compute firewall-rules delete allow-winrm
