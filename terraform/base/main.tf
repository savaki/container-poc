provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "main" {
  name = "lovingly/sample"
}

resource "aws_ecs_cluster" "main" {
  name = "lovingly"
}

output "repository_url" {
  value = "${aws_ecr_repository.main.repository_url}"
}
