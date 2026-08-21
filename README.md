**# Terraform-randomid-s3-static website deployment**

Automated Infrastructure-as-Code project that deploys a **static website on AWS S3** using **Terraform**, with **random ID generation controlled via Terraform**.  
This ensures globally unique bucket names and reproducible deployments.
Use article : https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html
<img width="1920" height="1280" alt="image" src="https://github.com/user-attachments/assets/4d0c0911-5864-421f-ad13-0648ceaff7f8" />


---

**## 📌 Prerequisites**

- AWS account with IAM user having `AmazonS3FullAccess` and `AmazonEC2FullAccess`
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (v1.5+ recommended)
- PowerShell (for random ID automation scripts)
---
**📂 Project Structure**

```
terraform-randomid-s3-static/
│── provider.tf
│── random.tf
│── main.tf
│── bucket-policy.tf
│── website.tf
│── objects.tf
│── ec2.tf
│── outputs.tf
│── variables.tf
│── index.html
│── style.css
```
---

**provider.tf**
```
Hcl
```
```
provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}

```
---

**random.tf**
```
Hcl
```
```
resource "random_id" "bucket_id" {
  byte_length = 4
}

```
---

**main.tf**
```
Hcl
```
```
resource "aws_s3_bucket" "project1_bucket" {
  bucket = "project1-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name        = "Project1Bucket"
    Environment = "Dev"
  }
}

# Disable Block Public Access at bucket level
resource "aws_s3_bucket_public_access_block" "project1_bucket_access" {
  bucket                  = aws_s3_bucket.project1_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

```
---

**bucket-policy.tf**
```
Json
```
```
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.project1_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.project1_bucket.bucket}/*"]
      }
    ]
  })
}

```

**website.tf**
```
Hcl
```
```
resource "aws_s3_bucket_website_configuration" "project1_bucket_website" {
  bucket = aws_s3_bucket.project1_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

```
---

**objects.tf**

Upload index.html and style.css files either on s3 bucket  or copy and paste code in terraform directories 
<img width="2021" height="1231" alt="image" src="https://github.com/user-attachments/assets/bd872e5b-088b-4160-9962-2bacb97f3ea1" />

```
Hcl
```
```
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.project1_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.project1_bucket.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}

```

---
**ec2.tf**

```
Hcl
```
```
resource "aws_instance" "project1_server" {
  ami           = "ami-023b6eace47afd3b4"
  instance_type = "t3.nano"
  tags = { Name = "project1_server" }
}
```
---

**outputs.tf**
```
hcl
```
```
output "bucket_name" {
  value = aws_s3_bucket.project1_bucket.bucket
}

output "bucket_region" {
  value = var.aws_region
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.project1_bucket_website.website_endpoint
}

```
---

**variables.tf**
```
Hcl
```
```
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-north-1"
}

```
---
**index.html**
```
html
```
```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Automated Static Website</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>Terraform + AWS S3 Deployment</h1>
    <p>Automated with Random ID</p>
  </header>
<main>
    <section>
      <h2>Project Code</h2>
      <pre>
resource "aws_s3_bucket" "static_site" {
  bucket = "my-static-site-${random_id.bucket_id.hex}"
  acl    = "public-read"
}
      </pre>
    </section>
<section>
      <h2>Troubleshooting</h2>
      <ul>
        <li><b>Bucket name already exists</b> → add random_id.</li>
        <li><b>Website not loading</b> → check S3 bucket policy.</li>
        <li><b>Files not visible</b> → ensure index.html is uploaded.</li>
      </ul>
    </section>
  </main>

<footer>
    <p>© 2026 Shruti | Powered by Terraform & AWS</p>
  </footer>
</body>
</html>
```
---

**style.css**
```
css
```
```
body {
  font-family: Arial, sans-serif;
  background: #f4f7fa;
  margin: 0;
  padding: 0;
}
header {
  background: #007acc;
  color: white;
  text-align: center;
  padding: 2rem;
}
h1 {
  margin: 0;
}
section {
  margin: 2rem;
}
pre {
  background: #272822;
  color: #f8f8f2;
  padding: 1rem;
  border-radius: 5px;
}
footer {
  background: #333;
  color: #fff;
  text-align: center;
  padding: 1rem;
}
```

---
**✅ Deployment Commands**

```
Bash
```
```
aws configure
terraform init
terraform plan
terraform apply
```
---
**🔎 Verify Website**

Your static site will be available at:

https://<your-bucket-name>.s3-website.<region>.amazonaws.com

---
