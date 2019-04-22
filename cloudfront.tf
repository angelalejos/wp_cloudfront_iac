#
# CloudFront distribution
#

locals {
	common_cookie_whitelist = [
		"comment_author_*",
		"_ga",
		"gadwp_*",
		"wordpress_*",
		"wp-settings-*"
	]
}

output "cf_domain_name" {
	value = "${aws_cloudfront_distribution.blog_distribution.domain_name}"
}

resource "aws_cloudfront_distribution" "blog_distribution" {
	aliases = "${var.blog_domain_names}"
	origin {
		domain_name = "${var.origin_domain_name}"
		origin_id = "${var.cf_origin_id}"
		custom_origin_config {
			http_port = 80
			https_port = 443
			origin_protocol_policy = "https-only"
			origin_ssl_protocols = ["TLSv1.2"]
			origin_keepalive_timeout = 45
		}
	}

	enabled = true
	is_ipv6_enabled = true

	logging_config {
		include_cookies = false
		bucket = "${var.cf_logging_bucket_name}.s3.amazonaws.com"
		prefix = "${var.cf_logging_bucket_prefix}"
	}

	default_cache_behavior {
		allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST",
			"PATCH", "DELETE"]
		cached_methods = ["GET", "HEAD", "OPTIONS"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values {
			# Be selective about which query string variables to
			# cache on. This list should only be changed after
			# very careful consideration.
			# - p: for URIs of the format /?p=1234
			# - s: for searches (/?s=search words)
			query_string = true
			query_string_cache_keys = ["p", "s"]
			cookies {
				forward = "whitelist"
				whitelisted_names = "${local.common_cookie_whitelist}"
			}
			headers = ["Host"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		default_ttl = "${var.cf_default_ttl}"
		max_ttl = "${var.cf_max_ttl}"
		compress = true
	}

	# wp-admin/*
	# - Don't cache
	ordered_cache_behavior {
		path_pattern = "${var.wp_root}/wp-admin/*"
		allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST",
			"PATCH", "DELETE"]
		cached_methods = ["GET", "HEAD", "OPTIONS"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values = {
			query_string = true
			cookies {
				forward = "whitelist"
				whitelisted_names = "${local.common_cookie_whitelist}"
			}
			# "All headers" disables caching
			headers = ["*"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		compress = true
	}

	# wp-content/*
	# - Cache for longer than default
	ordered_cache_behavior {
		path_pattern = "${var.wp_root}/wp-content/*"
		allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST",
			"PATCH", "DELETE"]
		cached_methods = ["GET", "HEAD", "OPTIONS"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values = {
			query_string = true
			cookies {
				forward = "whitelist"
				whitelisted_names = "${local.common_cookie_whitelist}"
			}
			headers = ["Host"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		default_ttl = 604800
		max_ttl = 604800
		compress = true
	}

	# wp-includes/*
	# - Cache for longer than default
	ordered_cache_behavior {
		path_pattern = "${var.wp_root}/wp-includes/*"
		allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST",
			"PATCH", "DELETE"]
		cached_methods = ["GET", "HEAD", "OPTIONS"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values = {
			query_string = true
			cookies {
				forward = "whitelist"
				whitelisted_names = "${local.common_cookie_whitelist}"
			}
			headers = ["Host"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		default_ttl = 604800
		max_ttl = 604800
		compress = true
	}

	# /apple-touch-icon*.png
	# - Cache for longer than default
	ordered_cache_behavior {
		path_pattern = "/apple-touch-icon*.png"
		allowed_methods = ["GET", "HEAD"]
		cached_methods = ["GET", "HEAD"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values = {
			query_string = true
			cookies {
				forward = "whitelist"
				whitelisted_names = "${local.common_cookie_whitelist}"
			}
			headers = ["Host"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		default_ttl = 604800
		max_ttl = 604800
		compress = true
	}

	# /favicon.ico
	# - Cache for longer than default
	ordered_cache_behavior {
		path_pattern = "/favicon.ico"
		allowed_methods = ["GET", "HEAD"]
		cached_methods = ["GET", "HEAD"]
		target_origin_id = "${var.cf_origin_id}"

		forwarded_values = {
			query_string = true
			cookies {
				forward = "none"
			}
			headers = ["Host"]
		}

		viewer_protocol_policy = "redirect-to-https"

		min_ttl = 0
		default_ttl = 604800
		max_ttl = 604800
		compress = true
	}

	price_class = "${var.cf_priceclass}"

	restrictions {
		geo_restriction {
			restriction_type = "none"
		}
	}

	viewer_certificate {
		acm_certificate_arn = "${var.acm_cert_arn}"
		ssl_support_method = "sni-only"
		minimum_protocol_version = "TLSv1.1_2016"
	}

	tags = "${var.tags}"
}

