## Infrastructure as Code: Blogging Backed by AWS

These Terraform rules will instantiate the following services for integration
with my personal blog(s):

- CloudFront
- S3 (logging bucket)

Be sure to create `terraform.tfvars` and set the required variables. Run
`terraform plan` to see a list of variables that need to be set.

