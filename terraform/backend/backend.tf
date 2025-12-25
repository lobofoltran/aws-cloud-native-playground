terraform {
  backend "s3" {
    bucket         = "aws-cloud-native-playground-tfstate"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
