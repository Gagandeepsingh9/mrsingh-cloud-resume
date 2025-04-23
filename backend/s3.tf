resource "aws_s3_bucket" "mystatebucket" {
    bucket = "my-terraform-state-gs"
    
}

resource "aws_s3_bucket_versioning" "bucketversioning" {
  bucket = aws_s3_bucket.mystatebucket.id
  versioning_configuration {
    status = "Enabled"
  }
}