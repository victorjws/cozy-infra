data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file("ssh-key.pub")
}

resource "aws_instance" "backend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.ssh-key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.allow_tls.id, aws_security_group.allow_ssh.id]

  tags = {
    "Name" = "cozy"
  }
  tags_all = {
    "Name" = "cozy"
  }
}

output "ec2_public_ip" {
  value = aws_instance.backend.public_ip
}
