# Why we need ECS instance policies http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# ECS roles explained here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html
# Some other ECS policy examples http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html

provider "aws" {
  region = "us-east-1"
}

data "aws_subnet" "main" {
  id = "${var.subnet_id}"
}

resource "aws_iam_role" "task_role" {
  name = "lovingly_task"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_policy" {
  role = "${aws_iam_role.task_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "execution_role" {
  name = "lovingly_execution"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role = "${aws_iam_role.execution_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role = "${aws_iam_role.execution_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_ecs_task_definition" "app" {
  family = "app"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = "${var.container_cpu}"
  memory = "${var.container_memory}"
  execution_role_arn = "${aws_iam_role.execution_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "receiver",
    "image": "${var.container_image}",
    "cpu": ${var.container_cpu},
    "memory": ${var.container_memory},
    "name": "app",
    "task_role_arn": "${aws_iam_role.task_role.arn}",
    "essential": true
  }
]
DEFINITION
}

# ALB Security group
# This is the group you need to edit if you want to restrict access to your application
resource "aws_security_group" "main" {
  name = "lovingly-ecs"
  description = "access control for contain instance"
  vpc_id = "${data.aws_subnet.main.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
resource "aws_ecs_service" "main" {
  name = "sqs-publisher-poc"
  cluster = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count = "1"
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [
      "${aws_security_group.main.id}"
    ]
    subnets = [
      "${data.aws_subnet.main.id}"
    ]
  }
}
