#
# Provider variables
#

variable "aws_profile" {
	default = "blogadmin"
}

variable "aws_region" {}

#
# General variables
#

variable "blog_domain_names" { type="list" }
variable "blog_primary_domain_name" {}
variable "origin_domain_name" {}

variable "tags" { type="map" }

#
# CloudFront variables
#

variable "cf_origin_id" {}
variable "cf_logging_bucket_name" {}
variable "cf_logging_bucket_prefix" {}
variable "cf_priceclass" {
	default = "PriceClass_200"
}

variable "acm_cert_arn" {}
