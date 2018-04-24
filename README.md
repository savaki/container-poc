lovingly
--------

**Note**: There are still some issues around the deployment process that need to be worked out, 
so this should not be considered a complete POC. 

`lovingly` provides a poc of using a FARGATE hosted container to read content 
from an SQS queue and publish those contents to an http endpoint.

### Prerequisites

* ensure `terraform` is installed. [Download Terraform](https://www.terraform.io/downloads.html)
* ensure aws credentials are configured in environment `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

### Setup Infrastructure

The infrastructure for this environment consists of:

* AWS elastic container registry (ECR) to host docker image
* AWS FARGATE ECS container to run docker images

Note: Unless docker containers are running, the only cost for these services
is the space used by the docker images (charged at standard S3 rates).

```bash
cd terraform/base
terraform init
terraform apply -auto-approve
```

Terraform apply will generate the following output:

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

repository_url = 621410822360.dkr.ecr.us-east-1.amazonaws.com/lovingly/sample
```

Save the `repository_url` for later.

## Build docker image

Two scripts have been provided to create the docker image.  We will want to configure
the repository url here:

```bash
export REPOSITORY_URL="<repository-url-from-setup>"
```

Once you've set that up, you can build the docker image:

```bash
docker/docker-build.sh
docker/docker-push.sh
```

This will publish the docker image to the repository.

## Deploy Service

Once the docker image has been pushed to the repository, we can deploy the service.

```
cd terraform/service
terraform init
terraform apply -auto-approve
```

This terraform script will do the following:

* create a security group for the docker container (if it doesn't exist)
* create a execution and task roles to define the permissions granted to the docker container
* create a task definition for the container
* create (or update) the service that will manage our container


## Running tests locally

The python scripts used can be tested locally:

generate a new message into the sqs queue, `sample`:

```bash
python3 post.py
```

read a message from the sqs queue, `sample`, and POST contents to `http://localhost:4000`

```bash
python3 reader.py
```

## Pros and Cons vs Lambda

### Pros

* **Easy to test locally**.  Both the scripts and the docker image can be run locally without
the need of additional software or wrappers.

* **Same image for production**.  Since the docker image is the same image that will be deployed,
one test it locally and feel confident there will be no issues when running in ECS.

* **Easy to reason about**.  Since the program is just a python script, there are few surprising
behaviors. 

### Cons

* Costlier than lambda.  As I've I've configured it, it's about $25/mo which is more than 
lambda (since I believe your usage will fall into Lambda's free tier)

## Not Included

As a poc, there are a number of things missing from this project:

* **Support for multiple environments**.  While you can certainly run the script multiple times
with different configurations, there's no inherent support for multiple environments.

* **Support for autoscaling**.  As a POC, I haven't bothered to add autoscaling support.
