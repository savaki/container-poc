#!/bin/bash

set -eu

export ROOT="$(cd $(dirname $0)/.. && pwd)"
export AWS_DEFAULT_REGION="us-east-1"
export IMAGE="${REPOSITORY_URL:=lovingly/sample}"

echo "# Building docker image -----------------------------------------"
echo "#"
#$(aws ecr get-login --no-include-email --region ${AWS_DEFAULT_REGION})
docker build -t ${IMAGE} ${ROOT}
echo ""
echo ""
echo "To test this docker container, you can run:"
echo ""

cat <<EOF
  docker run -it --rm \\
     -e AWS_ACCESS_KEY_ID=\${AWS_ACCESS_KEY_ID} \\
     -e AWS_SECRET_ACCESS_KEY=\${AWS_SECRET_ACCESS_KEY} \\
     -e AWS_DEFAULT_REGION=\${AWS_DEFAULT_REGION:=us-east-1} \\
     -e ENDPOINT=\${ENDPOINT} \\
     ${IMAGE}

EOF

