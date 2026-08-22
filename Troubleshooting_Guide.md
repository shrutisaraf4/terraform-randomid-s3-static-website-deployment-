#   🔧 Troubleshooting Guide: Static Website Deployment with Terraform + AWS S3 + EC2

***This guide covers common issues you may encounter when deploying a static website on AWS S3 using Terraform.***

---

##  **1. Terraform Errors**

###  ***❌ Error: `AccessDenied`***
- **Cause:** IAM user lacks required permissions.
- **Fix:** Ensure your IAM user has:
  - `AmazonS3FullAccess`
  - `AmazonEC2FullAccess`
  Run:
  ```
  bash
  ```
  ```
  aws configure
  ```
  
### **❌ Error: BucketAlreadyExists** 
- **Cause:** S3 bucket names must be globally unique.
- **Fix:** Confirm random_id is generating unique suffixes. 
Run:
```
bash
```
```
terraform apply -refresh-only
```
---

##   2. Website Not Loading 

🔒 Symptom: Access Denied

- **Cause:** Public access block not disabled or bucket policy missing.
- **Fix:** Ensure:
  
		- aws_s3_bucket_public_access_block values are set to false
		- Bucket policy allows s3:GetObject
    
📄 Symptom: 404 Not Found
- **Cause:** index.html not uploaded or wrong key name.
- **Fix:** Check objects.tf file paths. Verify with:
```
bash
```
```
terraform state list | grep aws_s3_object
```
---

##  3. EC2 Instance Issues

### ❌ Error: InvalidAMIID.NotFound
 - **Cause:** AMI ID not available in your region.
 - **Fix:** Update ami in ec2.tf with a valid AMI for your region.
   
### 🔌 Symptom: Instance not accessible
- **Cause:** Missing security group rules.
- **Fix:** Add inbound rules for SSH/HTTP in Terraform.
  
  ---
  
## ** 4. Deployment Verification**

### 🖥️ Symptom: Website endpoint not showing

- **Cause:** Missing output in outputs.tf.
- **Fix:** Ensure:
```
hcl
```
```
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.project1_bucket_website.website_endpoint
}
```

### 🎨 Symptom: Website loads but CSS not applied
- **Cause:**  Wrong MIME type or missing style.css.
- **Fix:** Confirm:
```
hcl
```
```
content_type = "text/css"
```

--- 

## **5. Debugging Commands**
### **Check bucket contents:**
```
bash
```
```
aws s3 ls s3://<bucket-name>
```
---
### **View bucket policy:**

```
bash
```
```
aws s3api get-bucket-policy --bucket <bucket-name>
```
---

### **Inspect Terraform state:**

```
bash
```
```
terraform state list
```

---

## ✅ Quick Checklist
	- [ ] IAM permissions correct
	- [ ] Bucket name unique
	- [ ] Public access block disabled
	- [ ] Bucket policy applied
	- [ ] index.html and style.css uploaded
	- [ ] Correct AMI ID for EC2
	- [ ] Outputs defined for website endpoint

---

© 2026 Shruti Saraf | Troubleshooting Guide for Automated Static Website Deployment



---
