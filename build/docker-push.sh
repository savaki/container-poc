#!/bin/bash

set -eu

export ROOT="$(cd $(dirname $0)/.. && pwd)"
export AWS_DEFAULT_REGION="us-east-1"
export IMAGE="${REPOSITORY_URL:=lovingly/sample}"

echo "# Pushing docker image ------------------------------------------"
echo "#"
echo "# image: ${IMAGE}"
echo "#"
$(aws ecr get-login --no-include-email --region ${AWS_DEFAULT_REGION})
echo docker push ${IMAGE}
docker push ${IMAGE}
echo "# Ok"
echo ""
