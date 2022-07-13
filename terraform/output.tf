output "lb_deploy_cmd" {
  value     = local.lb_deploy_cmd
  sensitive = true
}

output "lb_generate_cmd" {
  value     = local.lb_generate_cmd
  sensitive = true
}

output "APEX_URL" {
  value = oci_database_autonomous_database.autonomous_database.connection_urls[0].apex_url
}