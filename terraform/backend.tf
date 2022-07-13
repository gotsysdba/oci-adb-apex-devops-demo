terraform {
  backend "s3" {
    endpoint                    = "https://fro8fl9kuqli.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    region                      = "eu-frankfurt-1"
    bucket                      = "terraform-backend"
    key                         = "terraform.tfstate"
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}