resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-backend-bucket-jh"
  acl    = "private"

  tags = {
    Name = "tf_backend"
  }
}