####################################
# Security Group for ALB
####################################

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

####################################
# Security Group for EC2
####################################

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg"
  description = "Backend EC2 Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Backend API"

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Outbound"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-backend-sg"
  }
}