variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "myeventmap"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ecr_repository_name" {
  description = "myeventmap backend"
  type        = string
}

// needed for tracability and rollbacks

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

// ec2 and asg instances variables

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "database_url" {
  sensitive = true
  type      = string
}

variable "jwt_secret" {
  sensitive = true
  type      = string
}

variable "admin_email" {
  sensitive = true
  type      = string
}

variable "admin_password" {
  sensitive = true
  type      = string
}