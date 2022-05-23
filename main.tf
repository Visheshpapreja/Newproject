provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATANJI4WL5WASF4N2"
  secret_key = "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"
}

resource "aws_instance" "leader-instance" {
  ami           = "ami-079b5e5b3971bd10d"
  instance_type = "m5.xlarge"
  availability_zone = "ap-south-1a"
  key_name = "leader"
}
