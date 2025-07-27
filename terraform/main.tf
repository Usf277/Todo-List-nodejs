provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "ansible-key"
  public_key = file("/Users/usf277/.ssh/ansible-key.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from anywhere"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App" // allows inbound traffic on port 4000
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "todo_vm" {
  ami                    = "ami-0905a3c97561e0b69"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  root_block_device { // increase VM storage 8GB to 16GB
    volume_size           = 16
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "todo-vm"
  }
}
