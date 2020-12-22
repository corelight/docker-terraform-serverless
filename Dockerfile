FROM vault:1.6.1
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Serverless and Vault with Terraform for CI/CD"

#RUN wget -O /root/go1.15.1.linux-amd64.tar.gz "https://dl.google.com/go/go1.15.1.linux-amd64.tar.gz" && \
#    tar -C /usr/local -xzf /root/go1.15.1.linux-amd64.tar.gz
#
#RUN ln -s /usr/local/bin/go /usr/bin/go
#RUN ln -s /usr/local/bin/gofmt /usr/bin/gofmt

ARG GOLANG_VERSION=1.15.6

RUN wget --quiet https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip \
  && unzip terraform_0.12.29_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.12.29_linux_amd64.zip

RUN apk add --no-cache --update git bash openssh make nodejs nodejs-npm jq
RUN npm install -g serverless@1.66 \
    serverless-domain-manager \
    serverless-plugin-git-variables \
    serverless-prune-plugin \
    serverless-terraform-outputs
# Note: ignore "serverless update check failed" warning during "npm install"

# Heavyweight considering we only use awscli for configuration, presently.
RUN apk add --no-cache --update python3 py-pip groff && \
    pip install --upgrade awscli python-gitlab

RUN apk update && apk add go gcc bash musl-dev openssl-dev ca-certificates && update-ca-certificates

RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz

RUN cd /usr/local/go/src && ./make.bash

ENV PATH=$PATH:/usr/local/go/bin

RUN rm go$GOLANG_VERSION.src.tar.gz

#we delete the apk installed version to avoid conflict
RUN apk del go

RUN go version

RUN ln -s /usr/local/go/bin/go /usr/bin/go
RUN ln -s /usr/local/go/bin/gofmt/usr/bin/gofmt


RUN wget https://github.com/mitchellh/golicense/releases/download/v0.1.1/golicense_0.1.1_linux_x86_64.tar.gz &&\
    tar -xzf golicense_0.1.1_linux_x86_64.tar.gz -C tmp &&\
    mv tmp/golicense /usr/local/bin/golicense &&\
    rm -rf tmp &&\
    rm golicense_0.1.1_linux_x86_64.tar.gz


ENTRYPOINT ["/bin/bash", "-l", "-c"]
