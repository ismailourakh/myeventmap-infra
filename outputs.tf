output "alb_dns_name" {
  description = "Application Load Balancer DNS"

  value = aws_lb.backend.dns_name
}

output "alb_url" {
  description = "Application URL"

  value = "http://${aws_lb.backend.dns_name}"
}

output "frontend_bucket_name" {
  description = "S3 bucket used for the React frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_website_url" {
  description = "Public S3 website URL for the React frontend"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}