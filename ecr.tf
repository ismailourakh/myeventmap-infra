data "aws_ecr_repository" "backend" {
  name = var.ecr_repository_name
}