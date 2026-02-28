run "hub_vnet_eastus_production" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "hub"
    env           = "prdx"
    region        = "eastus"
    resource_type = "vnet"
    instance      = "001"
  }

  assert {
    condition     = output.name == "hub-prdx-use1-vnet-001"
    error_message = "Expected 'hub-prdx-use1-vnet-001', got '${output.name}'"
  }
}

run "hub_firewall_eastus_production" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "hub"
    env           = "prdx"
    region        = "eastus"
    resource_type = "afw"
    instance      = "001"
  }

  assert {
    condition     = output.name == "hub-prdx-use1-afw-001"
    error_message = "Expected 'hub-prdx-use1-afw-001', got '${output.name}'"
  }
}

run "storage_account_no_hyphens" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "platform"
    env           = "cicd"
    region        = "eastus"
    resource_type = "st"
    instance      = "001"
  }

  assert {
    condition     = output.name == "platformcicduse1st001"
    error_message = "Expected 'platformcicduse1st001', got '${output.name}'"
  }
}

run "container_app_staging" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "myapp"
    env           = "stgx"
    region        = "eastus"
    resource_type = "ca"
    instance      = "001"
  }

  assert {
    condition     = output.name == "myapp-stgx-use1-ca-001"
    error_message = "Expected 'myapp-stgx-use1-ca-001', got '${output.name}'"
  }
}

run "key_vault_no_hyphens" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "hub"
    env           = "prdx"
    region        = "eastus"
    resource_type = "kv"
    instance      = "001"
  }

  assert {
    condition     = output.name == "hubprdxuse1kv001"
    error_message = "Expected 'hubprdxuse1kv001', got '${output.name}'"
  }
}

run "resource_group_westeurope" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "hub"
    env           = "prdx"
    region        = "westeurope"
    resource_type = "rg"
    instance      = "001"
  }

  assert {
    condition     = output.name == "hub-prdx-euw1-rg-001"
    error_message = "Expected 'hub-prdx-euw1-rg-001', got '${output.name}'"
  }
}

run "nsg_westus2_dev" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "myapp"
    env           = "devx"
    region        = "westus2"
    resource_type = "nsg"
    instance      = "002"
  }

  assert {
    condition     = output.name == "myapp-devx-usw2-nsg-002"
    error_message = "Expected 'myapp-devx-usw2-nsg-002', got '${output.name}'"
  }
}

run "storage_account_truncation" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "longappname"
    env           = "prdx"
    region        = "eastus"
    resource_type = "st"
    instance      = "001"
  }

  assert {
    condition     = length(output.name) <= 24
    error_message = "Storage account name exceeds 24 characters: '${output.name}' (${length(output.name)} chars)"
  }
}

run "container_app_environment" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "myapp"
    env           = "prdx"
    region        = "eastus"
    resource_type = "cae"
    instance      = "001"
  }

  assert {
    condition     = output.name == "myapp-prdx-use1-cae-001"
    error_message = "Expected 'myapp-prdx-use1-cae-001', got '${output.name}'"
  }
}

run "log_analytics_workspace" {
  command = plan

  module {
    source = "./modules/naming"
  }

  variables {
    app           = "hub"
    env           = "prdx"
    region        = "eastus"
    resource_type = "log"
    instance      = "001"
  }

  assert {
    condition     = output.name == "hub-prdx-use1-log-001"
    error_message = "Expected 'hub-prdx-use1-log-001', got '${output.name}'"
  }
}
