terraform {
  backend "s3" {
    endpoint                    = "https://fro8fl9kuqli.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    region                      = "eu-frankfurt-1"
    bucket                      = "terraform-backend"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

// No need to get remote state data on production run, only dev
data "terraform_remote_state" "default" {
  count   = terraform.workspace == "default" ? 0 : 1
  backend = "s3"
  config = {
    endpoint                    = "https://fro8fl9kuqli.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    region                      = "eu-frankfurt-1"
    bucket                      = "terraform-backend"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}