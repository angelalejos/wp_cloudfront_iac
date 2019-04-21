#
# Provider variables
#

variable "aws_profile" {
	default = "default"
}

variable "aws_region" {}

#
# General variables
#

variable "blog_domain_names" { type="list" }
variable "origin_domain_name" {}

variable "wp_root" { default = "" }

variable "tags" { type="map" }

#
# CloudFront variables
#

variable "cf_default_ttl" { default = 3600 }
variable "cf_max_ttl" { default = 86400 }
variable "cf_origin_id" {}
variable "cf_logging_bucket_name" {}
variable "cf_logging_bucket_prefix" {}
variable "cf_priceclass" {
	default = "PriceClass_200"
}

variable "acm_cert_arn" {}
