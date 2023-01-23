output "slave_server_private_ips" {
  value = azurerm_network_interface.centos7.*.private_ip_address
}