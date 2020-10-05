FROM vault:1.5.3
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Serverless and Vault with Terraform for CI/CD"


RUN wget --quiet https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip \
  && unzip terraform_0.12.29_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.12.29_linux_amd64.zip

RUN apk add --no-cache --update git bash openssh make nodejs nodejs-npm jq
RUN npm install -g serverless \
    serverless-domain-manager \
    serverless-plugin-git-variables \
    serverless-prune-plugin \
    serverless-terraform-outputs
# Note: ignore "serverless update check failed" warning during "npm install"

# Heavyweight considering we only use awscli for configuration, presently.
RUN apk add --no-cache --update python3 py-pip groff && \
    pip install --upgrade awscli python-gitlab

ENTRYPOINT ["/bin/bash", "-l", "-c"]
