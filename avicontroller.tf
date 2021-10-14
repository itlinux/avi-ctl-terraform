data "template_file" "userdata" {
  template = file("files/userdata.json")
  vars = {
    password = var.admin_password
  }
}
# data "template_file" "cloud" {
#   template   = "${file("files/cloud.json")}"
#   vars       = {
#     password = "${var.admin_password}"
#   }
# }
resource "aws_instance" "remo-avi-controller" {
  count                       = var.controller_count
  user_data                   = "${count.index ==0 ? data.template_file.userdata.rendered :"" }"
  ami                         = lookup(var.ami-image, var.myregion)
  associate_public_ip_address = var.public_ip
  instance_type               = var.image-size
  subnet_id                   = var.se_subnet_id
  key_name                    = aws_key_pair.generated.key_name
  iam_instance_profile        = var.iam_profile
  vpc_security_group_ids      = [
      aws_security_group.remo_sg.id,
  ]
  tags                        = {
    Name                      = "ctl-avi-rm-${count.index +1}"
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
provider "avi" {
  avi_username   = var.admin_username
  avi_password   = var.admin_password
  avi_controller = aws_instance.remo-avi-controller[0].public_ip
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

# resource "avi_cluster" "aws_cluster" {
#   depends_on = [aws_instance.remo-avi-controller]
#   name       =  "cluster1-rm"
#   nodes {
#     ip {
#       type = "V4"
#       addr = aws_instance.remo-avi-controller[0].private_ip
#     }
#     name = "node01"
#   }
#   nodes {
#     ip {
#       type = "V4"
#       addr = aws_instance.remo-avi-controller[1].private_ip
#     }
#     name = "node02"
#   }
#   nodes {
#     ip {
#       type = "V4"
#       addr = aws_instance.remo-avi-controller[2].private_ip
#     }
#     name = "node03"
#   }
# }
