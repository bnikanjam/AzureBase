# ---------------------------------------------------------------------------
# State backend references (must match L0-bootstrap outputs)
# ---------------------------------------------------------------------------
state_resource_group_name  = "platform-cicd-use1-rg-001"
state_storage_account_name = "platformcicduse1st001"

# ---------------------------------------------------------------------------
# ALZ configuration
# ---------------------------------------------------------------------------
location                                  = "eastus"
architecture_name                         = "alz"
tenant_root_management_group_display_name = "Azure Landing Zones"

# ---------------------------------------------------------------------------
# Subscription placement – replace with real subscription IDs
# ---------------------------------------------------------------------------
management_subscription_id   = "00000000-0000-0000-0000-000000000000"
connectivity_subscription_id = "00000000-0000-0000-0000-000000000000"
identity_subscription_id     = "00000000-0000-0000-0000-000000000000"
