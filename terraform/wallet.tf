locals {
  db_name = lookup(oci_database_autonomous_database.autonomous_database, "db_name")
}

resource "oci_database_autonomous_database_wallet" "database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.autonomous_database.id
  password               = random_password.wallet_password.result
  base64_encode_content  = "true"
}

resource "local_sensitive_file" "database_wallet_file" {
  content_base64 = oci_database_autonomous_database_wallet.database_wallet.content
  filename       = "../wallet/Wallet_${local.db_name}.zip"
}