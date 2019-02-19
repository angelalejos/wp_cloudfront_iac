#
# S3 resources
#


resource "aws_s3_bucket" "cf_logs" {
	bucket = "${var.cf_logging_bucket_name}"
	acl = "private"

	lifecycle_rule {
		id = "log_rotate"
		enabled = true

		prefix = "${var.cf_logging_bucket_prefix}"

		expiration {
			days = 400
		}
	}

	tags = "${var.tags}"
}
