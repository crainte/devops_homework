terraform {
  # I know 1.0 is out, but this is what we use for work so sticking with it.
  required_version = "0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.30.0"
    }
  }
}
