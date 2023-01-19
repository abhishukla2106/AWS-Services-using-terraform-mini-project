resource "aws_instance" "Abhi" {
  instance_type = "t2.micro"
  ami           = var.ami1
  tags          = var.tag

}

# create aws security group
resource "aws_security_group" "demo-sg-k" {
  name        = var.s_Name
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = var.protocol1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.port1
    to_port     = var.port1
    protocol    = var.protocol1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# attach security group to ec2 instance

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.demo-sg-k.id
  network_interface_id = aws_instance.Abhi.primary_network_interface_id
}


# create EBS volume
resource "aws_ebs_volume" "demo-vol" {
  availability_zone = var.av-zone
  size              = 10

  tags = var.tag
}

#attach volume to punch5 instance
resource "aws_volume_attachment" "storage" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.Abhi.id
  volume_id   = aws_ebs_volume.demo-vol.id

}

#create snapshot from EBS volume
resource "aws_ebs_snapshot" "demo-snapshot" {
  volume_id = aws_ebs_volume.demo-vol.id

  tags = var.tag
}
#create vpc

resource "aws_vpc" "public_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  tags             = var.tag
}
# create one  public subnet
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.public_vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.av-zone2

  tags = var.tag
}
# create internet gateway

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.public_vpc.id

  tags = var.tag
}


# create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.public_vpc.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = var.tag
}
#attach route table to public subnet
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#create AMI from punch5 instance
resource "aws_ami_from_instance" "example" {
  name               = var.ami_name
  source_instance_id = aws_instance.Abhi.id
}