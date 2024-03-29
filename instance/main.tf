provider "aws" {
    region="us-east-1"
}

resource "aws_instance" "terraform-instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = var.tags
    security_groups = ["${aws_security_group.ssh_conection.name}"]
}

resource "aws_security_group" "ssh_conection" {
  name        = var.sg_name
  description = "Allow SSH inbound traffic"

  dynamic "ingress"{
      for_each = var.ingress_rules
      content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
      }
  }
  
  dynamic "egress"{
      for_each = var.egress_rules
      content {
            from_port   = egress.value.from_port
            to_port     = egress.value.to_port
            protocol    = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
      }
  }

}

output "instance_ip"{
    value   = aws_instance.terraform-instance.*.public_ip
}