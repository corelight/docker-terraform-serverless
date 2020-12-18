FROM vault:1.6.0
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Serverless and Vault with Terraform for CI/CD"

RUN apk add --no-cache --update git bash openssh make nodejs nodejs-npm jq
RUN npm install -g serverless@1.66 \
    serverless-domain-manager \
    serverless-plugin-git-variables \
    serverless-prune-plugin \
    serverless-terraform-outputs
# Note: ignore "serverless update check failed" warning during "npm install"

RUN apk upgrade
# Heavyweight considering we only use awscli for configuration, presently.
RUN apk add --no-cache --update python3 py-pip groff go && \
    pip install --upgrade awscli python-gitlab

ENTRYPOINT ["/bin/bash", "-l", "-c"]
