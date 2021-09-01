resource "aws_key_pair" "my-key" {
  key_name   = "Devops14-2021-tf-key"
  public_key = file("${path.module}/my_file.txt")
}

resource "aws_instance" "ec2" {
  ami           = lookup(var.ami, var.region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.my-key.key_name
  tags = {
    "Name" = element(var.tags, 0)
  }
}

resource "aws_security_group" "dynamic-sg" {
  name = var.common_tags
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol
      cidr_blocks = var.cidr
    }
  }
  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.protocol
      cidr_blocks = var.cidr
    }
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.dynamic-sg.id
  network_interface_id = aws_instance.ec2.primary_network_interface_id
}
resource "aws_eip" "my-eip" {
  vpc = true
  tags = {
    Name  = var.common_tags
    Owner = "Marko"
  }
}

resource "aws_eip_association" "my_eip_to_ec2" {
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.my-eip.id

}

output "eip" {
  value = aws_eip.my-eip.public_ip
}