# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# REGION
provider "aws" {
    region = "us-east-1"
    shared_credentials_file = ".aws/credentials"
}

# BUCKET S3
resource "aws_s3_bucket" "s3-bucket" {
  bucket = "s3-bucket"
}

# STATIC SITE
resource "aws_s3_bucket_website_configuration" "Site-bucket" {
  bucket = aws_s3_bucket.s3-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ACL S3
resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.s3-bucket.id

  acl = "public-read"
}

#S3 UPLOAD OBJECT
resource "aws_s3_bucket_object" "error" {
  key = "error.html"
  bucket = aws_s3_bucket.s3-bucket.id
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "index" {
  key = "index.html"
  bucket = aws_s3_bucket.bucket.id
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# POLICY S3
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.s3-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect     = "Allow",
        Principal  = "*",
        Action    = "s3:GetObject",
        Resource = "arn:aws:s3:::s3-95128/*",
      }
    ]
	})
}

# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}