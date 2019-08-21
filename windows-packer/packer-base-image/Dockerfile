# Container for running HashiCorp Packer
FROM hashicorp/packer:1.4.2
LABEL maintainer="Gordon Young <gjyoung1974@gmail.com>"

USER root

ENV ADMIN_PWD_CIPHERTEXT=""
ENV ARTIFACT_BUCKET=""
ENV GCLOUD_SERVICE_KEY=""
ENV GOOGLE_APPLICATION_CREDENTIALS=""
ENV GOOGLE_COMPUTE_ZONE=""
ENV GOOGLE_PROJECT_ID=""
ENV GCP_NETWORK_ID=""
ENV GCP_SUBNET_ID=""
ENV SECRETS_KEY=""
ENV SECRETS_KEYRING=""

# Add GCloud SDK to hashicorp/packer
RUN PATH=$PATH:/drone/src/google-cloud-sdk/bin && \
    apk add --update python tar python-dev py-pip build-base curl zip bash    && \
    curl https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz > gcloud.tar.gz    && \
    tar -xvzf ./gcloud.tar.gz    && \
    bash ./google-cloud-sdk/install.sh -q
