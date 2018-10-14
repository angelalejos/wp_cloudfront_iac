#
# S3 resources
#


resource "aws_s3_bucket" "cf_logs" {
	bucket = "${var.cf_logging_bucket_name}"
	acl = "private"

	tags = "${var.tags}"
}
