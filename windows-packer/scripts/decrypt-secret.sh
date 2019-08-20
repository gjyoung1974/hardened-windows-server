#!/bin/bash
# unwrap/reveal a password or "secret" with the GCP KMS

keyring="acme-ad-secrets"
key="acme-ad-secrets-key"

secret=$(echo -n "$1" | base64 --decode | gcloud kms decrypt \
  --ciphertext-file=- \
  --plaintext-file=- \
  --key=${key} \
  --keyring=${keyring} \
  --location=global
)

echo $secret
