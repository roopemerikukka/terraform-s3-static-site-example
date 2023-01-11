resource "aws_s3_bucket" "webapp" {
  bucket = var.domain_name
}

data "aws_s3_bucket" "webapp_selected" {
  bucket = aws_s3_bucket.webapp.bucket
}

resource "aws_s3_bucket_acl" "webapp_acl" {
  bucket = data.aws_s3_bucket.webapp_selected.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "webapp_versioning" {
  bucket = data.aws_s3_bucket.webapp_selected.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "webapp_policy" {
  bucket = data.aws_s3_bucket.webapp_selected.id
  policy = data.aws_iam_policy_document.webapp_iam_policy.json
}

data "aws_iam_policy_document" "webapp_iam_policy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.domain_name}",
      "arn:aws:s3:::${var.domain_name}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "webapp_website_conf" {
  bucket = data.aws_s3_bucket.webapp_selected.id
  index_document {
    suffix = "index.html"
  }
}