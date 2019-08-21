# Container for running HashiCorp Packer
# docker build -t gjyoung1974/aws-packer .
FROM hashicorp/packer:1.4.2
LABEL maintainer="Gordon Young <gjyoung1974@gmail.com>"
LABEL project="gjyoung1974/aws-packer"
LABEL org="com.gjyoung1974.cloud.utils.packer.aws"

ENV AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION
ENV ADMIN_PWD_CIPHERTEXT
ENV ARTIFACT_BUCKET
ENV SECRETS_KEY

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap

RUN pip install --upgrade pip

RUN pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ADD ./awscli-latest.sh awscli-latest.sh
ADD ./s3cmd-latest.sh s3cmd-latest.sh

VOLUME /root/.aws
VOLUME /project
WORKDIR /project
