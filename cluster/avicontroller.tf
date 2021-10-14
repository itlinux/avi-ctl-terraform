terraform {
  required_providers {
    avi = {
      source = "vmware/avi"
      version = "21.1.1"
    }
  }
}
provider "avi" {
  avi_username   = var.admin_username
  avi_password   = var.admin_password
  avi_controller = var.Controller_PublicIP.value[0]
  avi_tenant     = "admin"
}
# resource "avi_useraccount" "avi_user" {
#   username     = "admin"
#   old_password = var.old_password
#   password     = var.admin_password
# }
 # resource "avi_useraccount" "avi_user" {
 #   username     = "remo"
 #   password     = var.admin_password
 #   depends_on = [aws_instance.remo-avi-controller,avi_useraccount.avi_user]
 # }
# resource "avi_useraccount" "avi_user" {
#   username     = var.admin_username
#   old_password = var.old_password
#   password     = var.admin_password
# }

resource "avi_cluster" "aws_cluster" {
  name       =  "cluster1-rm"
  nodes {
    ip {
      type     = "V4"
      addr     = var.Controller_PrivateIP.value[0]
    }
    name = "node01"
    password = var.admin_password
  }
  nodes {
    ip {
      type     = "V4"
      addr     = var.Controller_PrivateIP.value[1]
  }
    name = "node02"
    password = var.old_password
  }
  nodes {
    ip {
      type = "V4"
      addr = var.Controller_PrivateIP.value[2]
    }
    name = "node03"
    password = var.old_password
  }
}
