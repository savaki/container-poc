# app_image contains the name of the app image, should look something like:
# 621410822360.dkr.ecr.us-east-1.amazonaws.com/lovingly/sample
variable "container_image" {
  default = "621410822360.dkr.ecr.us-east-1.amazonaws.com/lovingly/sample:latest"
}

# subnet_id defines the subnet that this container will appear within
# make sure this subnet has access to the internet
variable "subnet_id" {
  default = "subnet-ab9004dc"
}

# queue_name defines the sqs queue to be read from
variable "queue_name" {
  default = "sample"
}

# endpoint defines the http endpoint that will receive the message
variable "endpoint" {
  default = "http://requestbin.fullcontact.com/tn6lpktn"
}

##############################################################################
##
## below this point are configurations that probably don't need to be changed
##
##############################################################################

# cluster_name contains the name of the ECS cluster to create.
variable cluster_name {
  default = "lovingly"
}

# container_cpu defines the amount of cpu capacity to give to the container
# 1024 = 1 core
variable "container_cpu" {
  default = "512"
}

# container_memory defines the amount of memory to give to the container
# 1024 = 1gb
variable "container_memory" {
  default = "1024"
}
