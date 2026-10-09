data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "al2023-ami-*-x86_64"
    ]
  }

  filter {
    name = "state"

    values = [
      "available"
    ]
  }
}

resource "aws_launch_template" "backend" {

  name_prefix = "${var.project_name}-"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = [
    aws_security_group.backend.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.backend.name
  }

  user_data = base64encode(templatefile(
    "${path.module}/userdata.sh.tpl",
    {
      aws_region     = var.aws_region
      repository_url = data.aws_ecr_repository.backend.repository_url
      image_tag      = var.image_tag

      database_url   = var.database_url
      jwt_secret     = var.jwt_secret
      admin_email    = var.admin_email
      admin_password = var.admin_password
    }
  ))

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-backend"
    }

  }

}