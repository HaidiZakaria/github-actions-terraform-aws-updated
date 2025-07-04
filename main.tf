provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "github-actions-key-v2" # Updated name to avoid duplication
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg-v2" # Updated name to avoid duplication
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 for eu-west-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_sg.name]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  tags = {
    Name = "Terraform-Web-Server"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
