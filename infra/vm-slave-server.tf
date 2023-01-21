resource "azurerm_linux_virtual_machine" "centos7" {
  count                           = var.slavecount
  name                            = "${var.prj}-${var.env}-${var.slavename}-${format("%02d", count.index + 1)}-vm"
  computer_name                   = var.slavename
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  custom_data                     = filebase64("${path.module}/vm-slave-server-cloud-init.sh")

  os_disk {
    name                 = "${var.prj}-${var.env}-${var.slavename}-${format("%02d", count.index + 1)}-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }

  network_interface_ids = [
    element(azurerm_network_interface.centos7.*.id, count.index)
  ]

  tags = {
    project     = var.prj
    environment = var.env
  }
}

# NIC設定
resource "azurerm_network_interface" "centos7" {
  count               = var.slavecount
  name                = "${var.prj}-${var.env}-${var.slavename}-${format("%02d", count.index + 1)}-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.slave.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.centos7.*.id, count.index)
  }

  tags = {
    project     = var.prj
    environment = var.env
  }
}

# Public IP
resource "azurerm_public_ip" "centos7" {
  count               = var.slavecount
  name                = "${var.prj}-${var.env}-${var.slavename}-${format("%02d", count.index + 1)}-vm-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    project     = var.prj
    environment = var.env
  }
}

# 自動シャットダウン設定
resource "azurerm_dev_test_global_vm_shutdown_schedule" "centos7" {
  count                 = var.slavecount
  virtual_machine_id    = element(azurerm_linux_virtual_machine.centos7.*.id, count.index)
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "0400"
  timezone              = "Tokyo Standard Time"
  notification_settings {
    enabled = false
  }

  tags = {
    project     = var.prj
    environment = var.env
  }
}