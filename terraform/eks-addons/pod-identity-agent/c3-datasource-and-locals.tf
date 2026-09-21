data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-ca-central-1-i1zfl3al"
    key    = "eks/dev/terraform.tfstate"
    region = "ca-central-1"
  }
}
