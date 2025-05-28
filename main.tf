

# # required AVM resources interfaces
# resource "azurerm_management_lock" "this" {
#   count = var.lock != null ? 1 : 0

#   lock_level = var.lock.kind
#   name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
#   scope      = azurerm_resource_group.TODO.id # TODO: Replace with your azurerm resource name
#   notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
# }

# resource "azurerm_role_assignment" "this" {
#   for_each = var.role_assignments

#   principal_id                           = each.value.principal_id
#   scope                                  = azurerm_resource_group.TODO.id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
#   condition                              = each.value.condition
#   condition_version                      = each.value.condition_version
#   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
#   principal_type                         = each.value.principal_type
#   role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
#   role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
#   skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
# }


# Main Oracle Autonomous Database resource
resource "azapi_resource" "autonomous_database" {
  type      = "Oracle.Database/autonomousDatabases@2025-03-01"
  parent_id = var.resource_group_resource_id
  name      = var.name
  location  = var.location

  schema_validation_enabled = false

  timeouts {
    create = "3h"
    update = "2h"
    delete = "1h"
  }

  body = {
    properties = {
      displayName                              = var.display_name
      computeCount                            = var.compute_count
      dataStorageSizeInTbs                    = var.data_storage_size_in_tbs
      adminPassword                           = var.admin_password
      dbVersion                               = var.db_version
      licenseModel                            = var.license_model
      dataBaseType                            = var.database_type
      computeModel                            = var.compute_model
      dbWorkload                              = var.db_workload
      permissionLevel                         = var.permission_level
      subnetId                                = var.subnet_id
      vnetId                                  = var.vnet_id
      characterSet                            = var.character_set
      ncharacterSet                           = var.ncharacter_set
      isAutoScalingEnabled                    = var.is_auto_scaling_enabled
      isAutoScalingForStorageEnabled          = var.is_auto_scaling_for_storage_enabled
      isMtlsConnectionRequired                = var.is_mtls_connection_required
      isLocalDataGuardEnabled                 = var.is_local_data_guard_enabled
      backupRetentionPeriodInDays             = var.backup_retention_period_in_days
      databaseEdition                         = var.database_edition
      cpuCoreCount                            = var.cpu_core_count
      dataStorageSizeInGbs                    = var.data_storage_size_in_gbs
      autonomousMaintenanceScheduleType       = var.autonomous_maintenance_schedule_type
      openMode                                = var.open_mode
      isPreviewVersionWithServiceTermsAccepted = var.is_preview_version_with_service_terms_accepted

      # Customer Managed Key configuration
      dynamic "customerManagedKey" {
        for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
        content {
          keyVaultKeyUri = customerManagedKey.value.key_vault_key_uri
          identityId     = customerManagedKey.value.identity_id
        }
      }

      # Customer contacts
      dynamic "customerContacts" {
        for_each = var.customer_contacts
        content {
          email = customerContacts.value.email
        }
      }

      # Long term backup schedule
      dynamic "longTermBackupSchedule" {
        for_each = var.long_term_backup_schedule != null ? [var.long_term_backup_schedule] : []
        content {
          isDisabled             = longTermBackupSchedule.value.is_disabled
          repeatCadence          = longTermBackupSchedule.value.repeat_cadence
          retentionPeriodInDays  = longTermBackupSchedule.value.retention_period_in_days
          timeOfBackup           = longTermBackupSchedule.value.time_of_backup
        }
      }

      # Scheduled operations
      dynamic "scheduledOperations" {
        for_each = var.scheduled_operations
        content {
          dayOfWeek = {
            name = scheduledOperations.value.day_of_week.name
          }
          scheduledStartTime = scheduledOperations.value.scheduled_start_time
          scheduledStopTime  = scheduledOperations.value.scheduled_stop_time
        }
      }
    }

    tags = var.tags
  }

  # Ignore changes to admin password to avoid recreation
  lifecycle {
    ignore_changes = [
      body.properties.adminPassword
    ]
  }
}


#########
######### Aplican??????
######### If so, hacne falta variables en locals



# # Diagnostic Settings
# resource "azurerm_monitor_diagnostic_setting" "this" {
#   for_each = var.diagnostic_settings

#   name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
#   target_resource_id             = azapi_resource.autonomous_database.id
#   storage_account_id             = each.value.storage_account_resource_id
#   eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
#   eventhub_name                  = each.value.event_hub_name
#   partner_solution_id            = each.value.marketplace_partner_resource_id
#   log_analytics_workspace_id     = each.value.workspace_resource_id
#   log_analytics_destination_type = each.value.log_analytics_destination_type

#   dynamic "enabled_log" {
#     for_each = each.value.log_categories
#     content {
#       category = enabled_log.value
#     }
#   }

#   dynamic "enabled_log" {
#     for_each = each.value.log_groups
#     content {
#       category_group = enabled_log.value
#     }
#   }

#   dynamic "metric" {
#     for_each = each.value.metric_categories
#     content {
#       category = metric.value
#     }
#   }
# }

# # Role Assignments
# locals {
#   role_definition_resource_substring = "providers/Microsoft.Authorization/roleDefinitions"
# }

# resource "azurerm_role_assignment" "this" {
#   for_each = var.role_assignments

#   scope                            = azapi_resource.autonomous_database.id
#   role_definition_id               = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
#   role_definition_name             = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
#   principal_id                     = each.value.principal_id
#   condition                        = each.value.condition
#   condition_version                = each.value.condition_version
#   skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
#   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
#   principal_type                   = each.value.principal_type
# }

# # Resource Lock
# resource "azurerm_management_lock" "this" {
#   count = var.lock != null ? 1 : 0

#   lock_level = var.lock.kind
#   name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
#   scope      = azapi_resource.autonomous_database.id
#   notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
# }

# # Private Endpoints - when managing DNS zone groups
# resource "azurerm_private_endpoint" "this" {
#   for_each = { for k, v in var.private_endpoints : k => v if var.private_endpoints_manage_dns_zone_group }

#   name                          = each.value.name != null ? each.value.name : "pep-${var.name}"
#   location                      = each.value.location != null ? each.value.location : var.location
#   resource_group_name           = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
#   subnet_id                     = each.value.subnet_resource_id
#   custom_network_interface_name = each.value.network_interface_name
#   tags                          = each.value.tags

#   private_service_connection {
#     name                           = each.value.private_service_connection_name != null ? each.value.private_service_connection_name : "pse-${var.name}"
#     private_connection_resource_id = azapi_resource.autonomous_database.id
#     is_manual_connection           = false
#     subresource_names              = [each.value.subresource_name]
#   }

#   dynamic "private_dns_zone_group" {
#     for_each = length(each.value.private_dns_zone_resource_ids) > 0 ? ["this"] : []
#     content {
#       name                 = each.value.private_dns_zone_group_name
#       private_dns_zone_ids = each.value.private_dns_zone_resource_ids
#     }
#   }

#   dynamic "ip_configuration" {
#     for_each = each.value.ip_configurations
#     content {
#       name               = ip_configuration.value.name
#       subresource_name   = each.value.subresource_name
#       member_name        = each.value.subresource_name
#       private_ip_address = ip_configuration.value.private_ip_address
#     }
#   }
# }

# # Private Endpoints - when NOT managing DNS zone groups
# resource "azurerm_private_endpoint" "this_unmanaged_dns_zone_groups" {
#   for_each = { for k, v in var.private_endpoints : k => v if !var.private_endpoints_manage_dns_zone_group }

#   name                          = each.value.name != null ? each.value.name : "pep-${var.name}"
#   location                      = each.value.location != null ? each.value.location : var.location
#   resource_group_name           = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
#   subnet_id                     = each.value.subnet_resource_id
#   custom_network_interface_name = each.value.network_interface_name
#   tags                          = each.value.tags

#   private_service_connection {
#     name                           = each.value.private_service_connection_name != null ? each.value.private_service_connection_name : "pse-${var.name}"
#     private_connection_resource_id = azapi_resource.autonomous_database.id
#     is_manual_connection           = false
#     subresource_names              = [each.value.subresource_name]
#   }

#   dynamic "ip_configuration" {
#     for_each = each.value.ip_configurations
#     content {
#       name               = ip_configuration.value.name
#       subresource_name   = each.value.subresource_name
#       member_name        = each.value.subresource_name
#       private_ip_address = ip_configuration.value.private_ip_address
#     }
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }
# }
