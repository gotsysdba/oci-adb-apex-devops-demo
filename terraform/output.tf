output "adbprd_name" {
  description = "DB_NAME for Prod ADB used in cloning"
  value       = join(", ", module.adb_prd[*].adb_name)
}

output "adbprd_id" {
  description = "OCID for Prod ADB used in cloning"
  value       = join(", ", module.adb_prd[*].adb_id)
}

output "lb_deploy_cmd" {
  value     = local.lb_deploy_cmd
  sensitive = true
}

output "lb_generate_cmd" {
  value     = local.lb_generate_cmd
  sensitive = true
}