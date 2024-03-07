
locals {

  bootstrap_params = {
    "vmseries-bootstrap-aws-s3bucket" = var.ngfw_bootstrap_bucket
  }

  bootstrap_options = merge(var.bootstrap_options, local.bootstrap_params)
}

data "aws_ami" "pa-vm" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = var.fw_product_code
  }

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version}*"]
  }
}

data "aws_region" "current" {}

data "aws_service" "s3" {
  region = data.aws_region.current.name
  service_id = "s3"
}

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id = var.vpc_id
#   service_name = data.aws_service.s3.reverse_dns_name
# }
# 
# resource "aws_vpc_endpoint_route_table_association" "s3" {
#   route_table_id = var.route_table_ids["${var.vpc_name}-ngfw-mgmt-rt"]
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
# }

resource "aws_network_interface" "this" {
  for_each = { for interface in var.fw_interfaces: interface.name => interface }

  subnet_id         = var.subnet_ids["${var.vpc_name}-${each.value.subnet_name}"]
  private_ips       = each.value.private_ips
  security_groups   = [var.security_groups["${var.prefix-name-tag}${each.value.security_group}"]]
  source_dest_check = each.value.source_dest_check
  tags = merge({ Name = "${var.prefix-name-tag}${each.value.name}" }, var.global_tags)
}

resource "aws_eip" "elasticip" {
  network_interface = aws_network_interface.this["vmseries01-mgmt"].id
  #vpc = true
}

resource "aws_instance" "vm-series" {
  for_each = { for firewall in var.firewalls: firewall.name => firewall }

  ami                   = data.aws_ami.pa-vm.id
  instance_type         = each.value.instance_type
  ebs_optimized         = true

  tags          = merge({ Name = "${var.prefix-name-tag}${each.value.name}" }, var.global_tags)

  user_data = base64encode(join(",", compact(concat(
    [for k, v in merge(each.value.bootstrap_options, local.bootstrap_options) : "${k}=${v}"],
  ))))

  root_block_device {
    delete_on_termination = true
  }

  key_name   = var.ssh_key_name

  dynamic "network_interface" {
    for_each = each.value.interfaces
    content {
      device_index         = network_interface.value.index
      network_interface_id = aws_network_interface.this[network_interface.value.name].id
    }
  }
}

output "ngfw-data-eni" {
  value = aws_network_interface.this["vmseries01-data"].id
}

output "ngfw-mgmt-eni" {
  value = aws_network_interface.this["vmseries01-mgmt"].id
}

output "firewall" {
  value = aws_instance.vm-series["vmseries01"]
}

output "firewall-ip" {
  value = aws_eip.elasticip.public_ip
}

