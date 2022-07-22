output "adb_id" {
  value = oci_database_autonomous_database.adb.id
}

output "adb_name" {
  value = oci_database_autonomous_database.adb.db_name
}

output "lb_params" {
  value = format("--dbName %s --dbPass %s --dbWallet %s", oci_database_autonomous_database.adb.db_name, random_password.adb_password.result, local_sensitive_file.database_wallet_file.filename)
}

output "APEX_URL" {
  value = oci_database_autonomous_database.adb.connection_urls[0].apex_url
}