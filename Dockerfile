FROM hashicorp/terraform:light
LABEL maintainer="Corelight AWS Team <aws@corelight.com>"
LABEL description="Serverless with Terraform for CI/CD"

RUN apk add --update git bash openssh make nodejs nodejs-npm
RUN npm install -g serverless serverless-plugin-git-variables serverless-terraform-outputs
# Note: ignore "serverless update check failed" warning during "npm install"

ENTRYPOINT ["/bin/bash", "-l", "-c"]
