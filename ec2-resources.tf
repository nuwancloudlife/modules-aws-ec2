data "aws_ami" "redhat" {
  count = (var.ubuntu == false && var.amzlinux == false && var.windows2019 == false ? 1 : 0)

  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-8.*.*_HVM-202*-x86_64-0-Hourly2-GP*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "ubuntu" {
  count = (var.redhat == false && var.amzlinux == false && var.windows2019 == false ? 1 : 0)

  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "amzlinux" {
  count = (var.redhat == false && var.ubuntu == false && var.windows2019 == false ? 1 : 0)

  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "windows2019" {
  count = (var.redhat == false && var.ubuntu == false && var.amzlinux == false ? 1 : 0)

  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  redhat_ami      = (var.redhat == true ? data.aws_ami.redhat[0].id : "")
  ubuntu_ami      = (var.ubuntu == true ? data.aws_ami.ubuntu[0].id : "")
  amzlinux_ami    = (var.amzlinux == true ? data.aws_ami.amzlinux[0].id : "")
  windows2019_ami = (var.windows2019 == true ? data.aws_ami.windows2019[0].id : "")
  final_ami       = coalesce(local.redhat_ami, local.ubuntu_ami, local.amzlinux_ami, local.windows2019_ami)
}

locals {
  port = (var.windows2019 == true ? 3389 : 22)
}

data "aws_subnet" "ec2_sg_cidr" {
  id = var.ec2_subnet
}

resource "aws_security_group" "ec2_sec_grp" {
  name        = join("-", [var.ec2_name, "sec-grp"])
  description = "EC2 Security Group"
  vpc_id      = var.ec2_vpc

  ingress {
    description = "SSH from Client"
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Traffic within Subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_subnet.ec2_sg_cidr.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("-", [(var.ec2_name == "" ? var.project : var.ec2_name), "sec-grp"])
  }
}

resource "aws_instance" "primary" {
  depends_on             = [aws_security_group.ec2_sec_grp]
  ami                    = local.final_ami
  availability_zone      = join("", [var.region, var.az_code])
  instance_type          = var.instance_type
  key_name               = var.ec2_key
  vpc_security_group_ids = [aws_security_group.ec2_sec_grp.id]
  subnet_id              = var.ec2_subnet

  root_block_device {
    volume_size = ( var.ebs_size == 8 && var.windows2019 == true ? 30 : var.ebs_size )
    volume_type = "gp3"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 4
    http_tokens                 = "required"
  }

  tags = {
    Name = var.ec2_name
  }
}

resource "aws_eip" "primary_eip" {
  instance = aws_instance.primary.id
}
