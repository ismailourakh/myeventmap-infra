#!/bin/bash
set -euxo pipefail

dnf update -y

# Install required packages
dnf install -y docker awscli

# Start Docker
systemctl enable --now docker

# Verify AWS CLI
aws --version

# Login to ECR
aws ecr get-login-password --region ${aws_region} \
  | docker login \
      --username AWS \
      --password-stdin ${repository_url}

# Pull image
docker pull ${repository_url}:${image_tag}

# Environment file
cat <<EOF >/home/ec2-user/.env
PORT=3000
DATABASE_URL=${database_url}
JWT_SECRET=${jwt_secret}
ADMIN_EMAIL=${admin_email}
ADMIN_PASSWORD=${admin_password}
EOF

# Run container
docker rm -f backend 2>/dev/null || true

docker run -d \
  --restart unless-stopped \
  --name backend \
  -p 3000:3000 \
  --env-file /home/ec2-user/.env \
  ${repository_url}:${image_tag}

# Show container status
docker ps