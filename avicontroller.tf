# data "template_file" "userdata" {
#   template = file("files/userdata.json")
#   vars = {
#     password = var.admin_password
#   }
# }


resource "aws_instance" "remo-avi-controller" {
  #user_data                   = data.template_file.userdata.rendered
  ami                         = lookup(var.ami-image, var.myregion) # ${var.ami-image}"
  associate_public_ip_address = var.public_ip
  instance_type               = var.image-size
  subnet_id                   = var.se_subnet_id
  key_name                    = aws_key_pair.generated.key_name
  iam_instance_profile        = var.iam_profile
  security_groups             = [aws_security_group.remo_sg.id]
  #security_groups            = [ "sg-0fca3888dc85dc8f1" ]
  tags                        = {
    Name                      = var.controller_name
    dept                      = var.department_name
    shutdown_policy           = var.shutdown_rules
    owner                     = var.owner
  }
}

terraform {
  required_providers {
    avi = {
      source = "vmware/avi"
      version = "21.1.1"
    }
  }
}
# provider "avi" {
#   avi_username   = var.admin_username
#   avi_password   = var.admin_password
#   avi_controller = aws_instance.remo-avi-controller.public_ip
#   avi_tenant     = "admin"
# }
#resource "avi_systemconfiguration" "avi_system" {
#    uuid                = "default-uuid"
#    #dns_configuration   = "8.8.8.8"
#    #email_configuration = "remo@avinetworks.com"
#    #ntp_configuration   = ["time.apple.com"
#    }

# resource "avi_useraccount" "avi_user" {
#   username     = "admin"
#   old_password = var.old_password
#   password     = var.admin_password
# }
resource "avi_useraccount" "avi_user" {
  username     = "admin"
  old_password = var.old_password
  password     = var.admin_password
  depends_on = [aws_instance.remo-avi-controller,avi_useraccount.avi_user]
}


# resource "avi_useraccount" "avi_user" {
#   username     = var.admin_username
#   old_password = var.old_password
#   password     = var.admin_password
# }

# resource "template_file" "cloud" {
#   template   = "${file("files/cloud.json")}"
#   vars       = {
#     password = "${var.admin_password}"
#   }
# }
# resource "avi_backupconfiguration" "backup_config" {
#     depends_on        = [aws_instance.remo-avi-controller]
#     name = "Backup-Configuration"
#     tenant_ref = "/api/tenant/?name=admin"
#     save_local = true
#     maximum_backups_stored = 4
#     backup_passphrase = "Password@12345"
#     configpb_attributes {
#         version = 1
#     }
# }

# resource "avi_backupconfiguration" "avi_backup" {
#   name              = "Backup-Configuration"
#   backup_passphrase = "Avi123test!"
#   depends_on        = [aws_instance.remo-avi-controller]
# }
