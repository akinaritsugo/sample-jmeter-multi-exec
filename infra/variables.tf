# Account Information
# ------------------------------------------
variable "SUBSCRIPTION_ID" {
  type = string
}

variable "TENANT_ID" {
  type = string
}

# Prefix Information
# ------------------------------------------
variable "location" {
  type    = string
  default = "japaneast"
}

variable "prj" {
  type = string
}

variable "env" {
  type = string
}

variable "mastername" {
  type = string
}

variable "slavename" {
  type = string
}

variable "slavecount" {
  type = number
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}