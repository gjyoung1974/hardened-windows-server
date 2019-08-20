#!/bin/bash
# Wrap a password or "secret" with the GCP KMS

keyring="acme-ad-secrets"
key="acme-ad-secrets-key"

secret=$(echo -n $1 | gcloud kms encrypt \
 --location global \
 --keyring ${keyring} \
 --key ${key} \
 --plaintext-file - \
 --ciphertext-file - \
 | base64)

 echo $secret
