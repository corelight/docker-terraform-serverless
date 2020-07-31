FROM hashicorp/terraform:0.12.29
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Serverless with Terraform for CI/CD"

RUN apk add --no-cache --update git bash openssh make nodejs nodejs-npm
RUN npm install -g serverless \
    serverless-domain-manager \
    serverless-plugin-git-variables \
    serverless-prune-plugin \
    serverless-terraform-outputs
# Note: ignore "serverless update check failed" warning during "npm install"

# Heavyweight considering we only use awscli for configuration, presently.
RUN apk add --no-cache --update python3 py-pip groff && \
    pip install --upgrade awscli python-gitlab

RUN ln -s /usr/bin/python3 /usr/bin/python

ENTRYPOINT ["/bin/bash", "-l", "-c"]
