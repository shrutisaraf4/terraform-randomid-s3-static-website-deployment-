**Static Website Deployment Using S3 Bucket - Fully Automated with Terraform**

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
<img width="580" height="617" alt="image" src="https://github.com/user-attachments/assets/efffcb13-2625-47e2-850a-62d5f93a1d85" />


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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Static Website Deployment Using S3 Bucket - Fully Automated</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <div class="container">
    <header>
      <h1>Static Website Deployment Using S3 Bucket - Fully Automated</h1>
      <p>Automated Infrastructure-as-Code project deploying a static website on AWS S3 using Terraform with dynamic random ID generation.</p>
      <div class="author-badge">✨ Fully Automated by Shruti Saraf</div>
    </header>

    <main>
      <!-- README Intro Section -->
      <section>
        <h2>📌 Project Overview</h2>
        <p>This automated Infrastructure-as-Code project deploys a static website on AWS S3 using Terraform, with random ID generation controlled via Terraform. This ensures globally unique bucket names and reproducible deployments.</p>
        <p>Reference Guide: <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html" target="_blank" style="color: #60a5fa;">AWS S3 Website Access Permissions</a></p>
      </section>

      <!-- Prerequisites -->
      <section>
        <h2>📌 Prerequisites</h2>
        <ul>
          <li>AWS account with IAM user having <code>AmazonS3FullAccess</code> and <code>AmazonEC2FullAccess</code></li>
          <li>AWS CLI installed and configured (<code>aws configure</code>)</li>
          <li>Terraform installed (v1.5+ recommended)</li>
        </ul>
      </section>

      <!-- Project Structure -->
      <section>
        <h2>📂 Project Structure</h2>
        <pre class="file-tree">terraform-randomid-s3-static/
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
│── style.css</pre>
      </section>

      <!-- Code Snippets -->
      <section>
        <h2>💻 Configuration Code Files</h2>

        <h3>provider.tf</h3>
        <pre><code>provider "aws" {
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
}</code></pre>

        <h3>random.tf</h3>
        <pre><code>resource "random_id" "bucket_id" {
  byte_length = 4
}</code></pre>

        <h3>main.tf</h3>
        <pre><code>resource "aws_s3_bucket" "project1_bucket" {
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
}</code></pre>

        <h3>bucket-policy.tf</h3>
        <pre><code>resource "aws_s3_bucket_policy" "bucket_policy" {
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
}</code></pre>

        <h3>website.tf</h3>
        <pre><code>resource "aws_s3_bucket_website_configuration" "project1_bucket_website" {
  bucket = aws_s3_bucket.project1_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}</code></pre>

        <h3>objects.tf</h3>
        <pre><code># Upload index.html and style.css files to S3 bucket via Terraform
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
}</code></pre>

        <h3>ec2.tf</h3>
        <pre><code>resource "aws_instance" "project1_server" {
  ami           = "ami-023b6eace47afd3b4"
  instance_type = "t3.nano"
  tags = { Name = "project1_server" }
}</code></pre>

        <h3>outputs.tf</h3>
        <pre><code>output "bucket_name" {
  value = aws_s3_bucket.project1_bucket.bucket
}

output "bucket_region" {
  value = var.aws_region
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.project1_bucket_website.website_endpoint
}</code></pre>

        <h3>variables.tf</h3>
        <pre><code>variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-north-1"
}</code></pre>
      </section>

      <!-- Deployment Commands -->
      <section>
        <h2>✅ Deployment Commands</h2>
        <pre><code>aws configure
terraform init
terraform plan
terraform apply</code></pre>
      </section>

      <!-- Verify Website -->
      <section>
        <h2>🔎 Verify Website</h2>
        <p>Your static site will be available at:</p>
        <pre><code>https://&lt;bucket-name&gt;.s3-website.&lt;region&gt;.amazonaws.com</code></pre>
      </section>
    </main>

    <footer>
      <p>© 2026 Shruti Saraf | Fully Automated Static Website Deployment on AWS</p>
    </footer>
  </div>

</body>
</html>
```
---

**style.css**
```
css
```
```
:root {
  --bg-color: #030712;
  --card-bg: rgba(15, 23, 42, 0.85);
  --border-color: rgba(255, 255, 255, 0.08);
  --text-main: #f3f4f6;
  --text-muted: #9ca3af;
  --accent-tf: #8b5cf6;
  --accent-aws: #f59e0b;
  --code-bg: #090d16;
  --code-text: #34d399;
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
}

body {
  background-color: var(--bg-color);
  color: var(--text-main);
  line-height: 1.6;
  background-image: 
    radial-gradient(circle at 15% 15%, rgba(139, 92, 246, 0.08) 0%, transparent 40%),
    radial-gradient(circle at 85% 85%, rgba(245, 158, 11, 0.06) 0%, transparent 40%);
  background-attachment: fixed;
  padding: 2rem 1rem;
}

.container {
  max-width: 900px;
  margin: 0 auto;
}

header {
  text-align: center;
  margin-bottom: 2.5rem;
  padding: 3rem 1.5rem;
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  backdrop-filter: blur(16px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.6);
}

header h1 {
  font-size: 2rem;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #ffffff, #9ca3af);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  line-height: 1.3;
}

header p {
  color: var(--text-muted);
  font-size: 1.05rem;
  max-width: 700px;
  margin: 0 auto;
}

.author-badge {
  display: inline-block;
  margin-top: 1.2rem;
  padding: 0.4rem 1.2rem;
  background: rgba(139, 92, 246, 0.15);
  border: 1px solid var(--accent-tf);
  color: #c4b5fd;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 600;
}

section {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 2rem;
  margin-bottom: 2rem;
  backdrop-filter: blur(16px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.4);
}

h2 {
  font-size: 1.35rem;
  margin-bottom: 1.2rem;
  color: #fff;
  border-bottom: 1px solid var(--border-color);
  padding-bottom: 0.6rem;
}

h3 {
  font-size: 1rem;
  color: #cbd5e1;
  margin: 1.2rem 0 0.4rem 0;
}

p, li {
  color: var(--text-muted);
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
}

ul {
  padding-left: 1.5rem;
}

li {
  margin-bottom: 0.5rem;
}

code {
  background: rgba(255, 255, 255, 0.05);
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
  font-family: 'Fira Code', monospace;
  font-size: 0.85rem;
  color: #f472b6;
}

pre {
  background: var(--code-bg);
  border: 1px solid var(--border-color);
  padding: 1.2rem;
  border-radius: 8px;
  overflow-x: auto;
  font-family: 'Fira Code', Consolas, Monaco, monospace;
  font-size: 0.85rem;
  color: var(--code-text);
  margin-top: 0.6rem;
}

.file-tree {
  color: #60a5fa;
}

footer {
  text-align: center;
  padding: 2rem;
  color: var(--text-muted);
  font-size: 0.85rem;
  border-top: 1px solid var(--border-color);
  margin-top: 3rem;
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
After apply it will display your static website url
Your static site will be available at: http://<your-bucket-name>.s3-website.<region>.amazonaws.com

<img width="1153" height="562" alt="image" src="https://github.com/user-attachments/assets/927cbcd3-6e8d-4747-a62d-59bb751b53c9" />



---
