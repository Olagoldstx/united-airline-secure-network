
resource "aws_vpc" "vpc" { cidr_block = "10.88.0.0/16" }

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.88.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "${var.aws_region}a"
}

resource "aws_security_group" "sg" {
  name   = "stc-ec2-sg"
  vpc_id = aws_vpc.vpc.id
  egress { from_port=0, to_port=0, protocol="-1", cidr_blocks=["0.0.0.0/0"] }
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "vm" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  metadata_options { http_endpoint="enabled", http_tokens="required" }
  user_data = <<-EOT
    #!/bin/bash
    dnf -y update
    systemctl enable --now amazon-ssm-agent || true
  EOT
  tags = { Name = "stc-ec2-secure" }
}

variable "aws_region" { default = "us-east-1" }
