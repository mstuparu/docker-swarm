provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
}

# AWS key
resource "aws_key_pair" "swarm_pub_key" {
  key_name   = "swarm"
  public_key = "${var.aws_ssh_pub_key}"
}

# Security group
resource "aws_security_group" "swarm_sg" {
vpc_id = "vpc-294ddc4c"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "90"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "4040"
    to_port     = "4040"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    self 	= "true"
  }

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "udp"
    self 	= "true"
  }

}

# EC2 app instances
resource "aws_instance" "ec2_swarm_instance" {
  ami                    = "ami-7abd0209"
  instance_type          = "t2.large"
  key_name               = "swarm"
  subnet_id		 = "subnet-70068a29"
  vpc_security_group_ids = ["${aws_security_group.swarm_sg.id}"]
  count                  = "3"

  root_block_device {
    volume_size = "100"
  }

  tags {
    Name = "${format("ec2-swarm-%02d", count.index+1)}"
    Role = "SwarmManager"
  }
}
