terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version="~>6.0"
      }
    }
backend "s3" {
    bucket         = "devgani-expense-dev"
    key            = "expense_tools"
    region         = "us-east-1"
    dynamodb_table = "devgani-expense-dev"
  }        
}

provider "aws" {
    region = "us-east-1"
}