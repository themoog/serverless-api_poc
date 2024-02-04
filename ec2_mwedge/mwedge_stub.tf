provider "aws" {
  region = "eu-west-2" # Change this to your AWS region
}

resource "aws_security_group" "txcore_poc_sg" {
  name        = "txcore_poc"
  description = "General API security group"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow API traffic"
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "txcore_poc"
  }
}

resource "aws_instance" "txcore_instance" {
  ami           = "ami-0780837dd83465d73" # Replace with your actual AMI ID
  instance_type = "t2.micro"
  key_name      = "btstuff"              # Make sure this key exists in your AWS account
  security_groups = [aws_security_group.txcore_poc_sg.name]

user_data = <<-EOF
#!/bin/bash
yum update -y
yum install python3-pip -y
pip3 install flask
yum install git -y
git clone https://github.com/themoog/serverless-api_poc.git /home/ec2-user/serverless-api_poc
EOF

  tags = {
    Name = "TxCorePOCInstance"
  }
}

output "instance_public_ip" {
  value = aws_instance.txcore_instance.public_ip
}
