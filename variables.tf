

# # required AVM interfaces
# # remove only if not supported by the resource
# # tflint-ignore: terraform_unused_declarations
# variable "customer_managed_key" {
#   type = object({
#     key_vault_resource_id = string
#     key_name              = string
#     key_version           = optional(string, null)
#     user_assigned_identity = optional(object({
#       resource_id = string
#     }), null)
#   })
#   default     = null
#   description = <<DESCRIPTION
# A map describing customer-managed keys to associate with the resource. This includes the following properties:
# - `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
# - `key_name` - The name of the key.
# - `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
# - `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
#   - `resource_id` - The resource ID of the user-assigned identity.
# DESCRIPTION
# }

# variable "diagnostic_settings" {
#   type = map(object({
#     name                                     = optional(string, null)
#     log_categories                           = optional(set(string), [])
#     log_groups                               = optional(set(string), ["allLogs"])
#     metric_categories                        = optional(set(string), ["AllMetrics"])
#     log_analytics_destination_type           = optional(string, "Dedicated")
#     workspace_resource_id                    = optional(string, null)
#     storage_account_resource_id              = optional(string, null)
#     event_hub_authorization_rule_resource_id = optional(string, null)
#     event_hub_name                           = optional(string, null)
#     marketplace_partner_resource_id          = optional(string, null)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
# A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

# - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
# - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
# - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
# - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
# - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
# - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
# - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
# - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
# - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
# - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
# DESCRIPTION
#   nullable    = false

#   validation {
#     condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
#     error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
#   }
#   validation {
#     condition = alltrue(
#       [
#         for _, v in var.diagnostic_settings :
#         v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
#       ]
#     )
#     error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
#   }
# }

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# # tflint-ignore: terraform_unused_declarations
# variable "managed_identities" {
#   type = object({
#     system_assigned            = optional(bool, false)
#     user_assigned_resource_ids = optional(set(string), [])
#   })
#   default     = {}
#   description = <<DESCRIPTION
# Controls the Managed Identity configuration on this resource. The following properties can be specified:

# - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
# - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
# DESCRIPTION
#   nullable    = false
# }

# variable "private_endpoints" {
#   type = map(object({
#     name = optional(string, null)
#     role_assignments = optional(map(object({
#       role_definition_id_or_name             = string
#       principal_id                           = string
#       description                            = optional(string, null)
#       skip_service_principal_aad_check       = optional(bool, false)
#       condition                              = optional(string, null)
#       condition_version                      = optional(string, null)
#       delegated_managed_identity_resource_id = optional(string, null)
#     })), {})
#     lock = optional(object({
#       kind = string
#       name = optional(string, null)
#     }), null)
#     tags                                    = optional(map(string), null)
#     subnet_resource_id                      = string
#     private_dns_zone_group_name             = optional(string, "default")
#     private_dns_zone_resource_ids           = optional(set(string), [])
#     application_security_group_associations = optional(map(string), {})
#     private_service_connection_name         = optional(string, null)
#     network_interface_name                  = optional(string, null)
#     location                                = optional(string, null)
#     resource_group_name                     = optional(string, null)
#     ip_configurations = optional(map(object({
#       name               = string
#       private_ip_address = string
#     })), {})
#   }))
#   default     = {}
#   description = <<DESCRIPTION
# A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

# - `name` - (Optional) The name of the private endpoint. One will be generated if not set.
# - `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
# - `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
# - `tags` - (Optional) A mapping of tags to assign to the private endpoint.
# - `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
# - `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
# - `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
# - `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
# - `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
# - `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
# - `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
# - `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
# - `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
#   - `name` - The name of the IP configuration.
#   - `private_ip_address` - The private IP address of the IP configuration.
# DESCRIPTION
#   nullable    = false
# }

# # This variable is used to determine if the private_dns_zone_group block should be included,
# # or if it is to be managed externally, e.g. using Azure Policy.
# # https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault/issues/32
# # Alternatively you can use AzAPI, which does not have this issue.
# variable "private_endpoints_manage_dns_zone_group" {
#   type        = bool
#   default     = true
#   description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
#   nullable    = false
# }

# variable "role_assignments" {
#   type = map(object({
#     role_definition_id_or_name             = string
#     principal_id                           = string
#     description                            = optional(string, null)
#     skip_service_principal_aad_check       = optional(bool, false)
#     condition                              = optional(string, null)
#     condition_version                      = optional(string, null)
#     delegated_managed_identity_resource_id = optional(string, null)
#     principal_type                         = optional(string, null)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
# A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

# - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
# - `principal_id` - The ID of the principal to assign the role to.
# - `description` - The description of the role assignment.
# - `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
# - `condition` - The condition which will be used to scope the role assignment.
# - `condition_version` - The version of the condition syntax. Valid values are '2.0'.
# - `delegated_managed_identity_resource_id` - The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
# - `principal_type` - The type of the principal_id. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

# > Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
# DESCRIPTION
#   nullable    = false
# }

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}


#############
############# New Variables
#############

#---------------------------------------
# REQUIRED VARIABLES
#---------------------------------------
# These variables must be provided when calling the module

variable "name" {
  type        = string
  description = "The name of the Oracle Autonomous Database resource."
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "TODO: validate. -> The name can only contain alphanumeric characters, underscores, and hyphens."
  }
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the resources will be deployed."
  nullable    = false
}

variable "display_name" {
  type        = string
  description = "The display name of the Autonomous Database."
  nullable    = false
}

variable "compute_count" {
  type        = number
  description = "The number of ECPU cores to enable. For compute model OCPU, the compute count is the number of OCPU cores to enable."
  nullable    = false

  validation {
    condition     = var.compute_count >= 1
    error_message = "The compute count must be at least 1."
  }
}

variable "data_storage_size_in_tbs" {
  type        = number
  description = "The size, in terabytes, of the data volume that will be created and attached to the database."
  nullable    = false

  validation {
    condition     = var.data_storage_size_in_tbs >= 1
    error_message = "The data storage size must be at least 1 TB."
  }
}

variable "admin_password" {
  type        = string
  description = "The password must be between 12 and 30 characters long, and must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. It cannot contain the double quote symbol (\") or the username \"admin\"."
  sensitive   = true
  nullable    = false

  validation {
    condition     = length(var.admin_password) >= 12 && length(var.admin_password) <= 30
    error_message = "The admin password must be between 12 and 30 characters long."
  }
}

variable "db_version" {
  type        = string
  description = "A valid Oracle Database version for Autonomous Database."
  default     = "19c"
  nullable    = false

  validation {
    condition     = contains(["19c", "21c", "23ai"], var.db_version)
    error_message = "The db_version must be one of: 19c, 21c, 23ai."
  }
}

variable "subnet_id" {
  type        = string
  description = "The resource ID of the subnet where the Autonomous Database will be deployed."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+/subnets/.+$", var.subnet_id))
    error_message = "The subnet ID must be a valid Azure subnet resource ID."
  }
}

variable "vnet_id" {
  type        = string
  description = "The resource ID of the virtual network where the Autonomous Database will be deployed."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+$", var.vnet_id))
    error_message = "The vnet ID must be a valid Azure virtual network resource ID."
  }
}

#---------------------------------------
# OPTIONAL VARIABLES - Database Configuration
#---------------------------------------
# These variables have default values and are optional

variable "license_model" {
  type        = string
  description = "The Oracle license model that applies to the Oracle Autonomous Database. Bring your own license (BYOL) allows you to apply your current on-premises Oracle software licenses to equivalent, highly automated Oracle PaaS and IaaS services in the cloud."
  default     = "LicenseIncluded"
  nullable    = false

  validation {
    condition     = contains(["LicenseIncluded", "BringYourOwnLicense"], var.license_model)
    error_message = "The license_model must be either 'LicenseIncluded' or 'BringYourOwnLicense'."
  }
}

variable "database_type" {
  type        = string
  description = "The Autonomous Database workload type. This cannot be updated in parallel with any of the following: licenseModel, dbEdition, cpuCoreCount, computeCount, computeModel, adminPassword, whitelistedIps, isMTLSConnectionRequired, openMode, permissionLevel, dbWorkload, privateEndpointLabel, nsgIds, dbVersion, isRefreshable, dbName, scheduledOperations, dbToolsDetails, isLocalDataGuardEnabled, or isFreeTier."
  default     = "Regular"
  nullable    = false

  validation {
    condition     = contains(["Regular", "Clone", "CrossRegionDataguard"], var.database_type)
    error_message = "The database_type must be one of: Regular, Clone, CrossRegionDataguard."
  }
}

variable "compute_model" {
  type        = string
  description = "The compute model of the Autonomous Database. This is required if using the computeCount parameter. If you choose ECPU, then you must specify computeCount and not cpuCoreCount."
  default     = "ECPU"
  nullable    = false

  validation {
    condition     = contains(["ECPU", "OCPU"], var.compute_model)
    error_message = "The compute_model must be either 'ECPU' or 'OCPU'."
  }
}

variable "db_workload" {
  type        = string
  description = "The Autonomous Database workload type. The following values are valid: OLTP - indicates an Autonomous Transaction Processing database, DW - indicates an Autonomous Data Warehouse database, AJD - indicates an Autonomous JSON Database, APEX - indicates an Autonomous Database with the Oracle APEX Application Development workload type."
  default     = "OLTP"
  nullable    = false

  validation {
    condition     = contains(["OLTP", "DW", "AJD", "APEX"], var.db_workload)
    error_message = "The db_workload must be one of: OLTP, DW, AJD, APEX."
  }
}

variable "permission_level" {
  type        = string
  description = "The Autonomous Database permission level. Restricted mode allows only admin access. Unrestricted mode allows admin access and enables other database users to be granted access to schema objects and services in this Autonomous Database."
  default     = "Restricted"
  nullable    = false

  validation {
    condition     = contains(["Restricted", "Unrestricted"], var.permission_level)
    error_message = "The permission_level must be either 'Restricted' or 'Unrestricted'."
  }
}

#---------------------------------------
# CHARACTER SET CONFIGURATION
#---------------------------------------
# Database character set and national character set settings

variable "character_set" {
  type        = string
  description = "The character set for the autonomous database. The default is AL32UTF8. Allowed values for an Autonomous Database on shared Exadata infrastructure as as returned by List Autonomous Database Character Sets."
  default     = "AL32UTF8"
  nullable    = false
}

variable "ncharacter_set" {
  type        = string
  description = "The national character set for the autonomous database. The default is AL16UTF16. Allowed values for an Autonomous Database on shared Exadata infrastructure as as returned by List Autonomous Database Character Sets."
  default     = "AL16UTF16"
  nullable    = false
}

#---------------------------------------
# SCALING AND PERFORMANCE CONFIGURATION
#---------------------------------------
# Auto-scaling and performance-related settings

variable "is_auto_scaling_enabled" {
  type        = bool
  description = "Indicates if auto scaling is enabled for the Autonomous Database OCPU core count. The default value is FALSE."
  default     = false
  nullable    = false
}

variable "is_auto_scaling_for_storage_enabled" {
  type        = bool
  description = "Indicates if auto scaling is enabled for the Autonomous Database storage. The default value is FALSE."
  default     = false
  nullable    = false
}

variable "cpu_core_count" {
  type        = number
  description = "The number of OCPU cores to be made available to the database. For Autonomous Databases on dedicated Exadata infrastructure, the maximum number of cores is determined by the infrastructure shape."
  default     = null

  validation {
    condition     = var.cpu_core_count == null || var.cpu_core_count >= 1
    error_message = "The CPU core count must be at least 1 if specified."
  }
}

variable "data_storage_size_in_gbs" {
  type        = number
  description = "The size, in gigabytes, of the data volume that will be created and attached to the database. This storage can later be scaled up if needed. The maximum storage value is determined by the infrastructure shape."
  default     = null

  validation {
    condition     = var.data_storage_size_in_gbs == null || var.data_storage_size_in_gbs >= 20
    error_message = "The data storage size must be at least 20 GB if specified."
  }
}

#---------------------------------------
# SECURITY AND CONNECTION CONFIGURATION
#---------------------------------------
# Security, connectivity, and encryption settings

variable "is_mtls_connection_required" {
  type        = bool
  description = "Indicates whether the Autonomous Database requires mTLS connections."
  default     = true
  nullable    = false
}

variable "is_local_data_guard_enabled" {
  type        = bool
  description = "Indicates whether the Autonomous Database has local (in-region) Data Guard enabled. Not applicable to cross-region Autonomous Data Guard associations, or to Autonomous Databases using dedicated Exadata infrastructure or Exadata Cloud@Customer infrastructure."
  default     = false
  nullable    = false
}

variable "open_mode" {
  type        = string
  description = "Indicates the Autonomous Database mode. The database can be opened in READ_ONLY or READ_WRITE mode."
  default     = "ReadWrite"
  nullable    = false

  validation {
    condition     = contains(["ReadOnly", "ReadWrite"], var.open_mode)
    error_message = "The open_mode must be either 'ReadOnly' or 'ReadWrite'."
  }
}

#---------------------------------------
# BACKUP AND MAINTENANCE CONFIGURATION
#---------------------------------------
# Backup retention, maintenance, and database edition settings

variable "backup_retention_period_in_days" {
  type        = number
  description = "Retention period, in days, for backups."
  default     = 7
  nullable    = false

  validation {
    condition     = var.backup_retention_period_in_days >= 1 && var.backup_retention_period_in_days <= 60
    error_message = "The backup retention period must be between 1 and 60 days."
  }
}

variable "database_edition" {
  type        = string
  description = "The Oracle Database Edition that applies to the Autonomous databases."
  default     = "EnterpriseEdition"
  nullable    = false

  validation {
    condition     = contains(["StandardEdition", "EnterpriseEdition"], var.database_edition)
    error_message = "The database_edition must be either 'StandardEdition' or 'EnterpriseEdition'."
  }
}

variable "autonomous_maintenance_schedule_type" {
  type        = string
  description = "The maintenance schedule type of the Autonomous Database Serverless. An EARLY maintenance schedule follows a schedule applying patches prior to the REGULAR schedule. A REGULAR maintenance schedule follows the normal cycle."
  default     = "Regular"
  nullable    = false

  validation {
    condition     = contains(["Early", "Regular"], var.autonomous_maintenance_schedule_type)
    error_message = "The autonomous_maintenance_schedule_type must be either 'Early' or 'Regular'."
  }
}

#---------------------------------------
# PREVIEW AND ADVANCED FEATURES
#---------------------------------------
# Preview features and advanced configuration options

variable "is_preview_version_with_service_terms_accepted" {
  type        = bool
  description = "If set to TRUE, indicates that an Autonomous Database preview version is being provisioned, and that the Preview Terms of Service have been accepted."
  default     = false
  nullable    = false
}

variable "customer_contacts" {
  type = list(object({
    email = string
  }))
  description = <<DESCRIPTION
List of customer contact email addresses for notifications.

- `email` - The email address for customer contact notifications.
DESCRIPTION
  default     = []
  nullable    = false
}

variable "long_term_backup_schedule" {
  type = object({
    is_disabled             = optional(bool, false)
    repeat_cadence          = optional(string, "Monthly")
    retention_period_in_days = optional(number, 90)
    time_of_backup          = optional(string, "02:00")
  })
  description = <<DESCRIPTION
Details for the long-term backup schedule:

- `is_disabled` - (Optional) Indicates if the long-term backup schedule is disabled. Defaults to false.
- `repeat_cadence` - (Optional) The frequency of the long-term backup schedule. Defaults to 'Monthly'.
- `retention_period_in_days` - (Optional) The retention period for long-term backups in days. Defaults to 90.
- `time_of_backup` - (Optional) The time of day to perform the backup. Defaults to '02:00'.
DESCRIPTION
  default     = null
}

variable "scheduled_operations" {
  type = list(object({
    day_of_week = object({
      name = string
    })
    scheduled_start_time = string
    scheduled_stop_time  = string
  }))
  description = <<DESCRIPTION
List of scheduled operations for the Autonomous Database:

- `day_of_week` - Object containing the name of the day (e.g., "Monday", "Tuesday", etc.)
- `scheduled_start_time` - The time to start the database (HH:MM format)
- `scheduled_stop_time` - The time to stop the database (HH:MM format)
DESCRIPTION
  default     = []
  nullable    = false
}

