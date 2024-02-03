provider "aws" {
  region = "eu-west-2" # Change this to your AWS region
}

resource "aws_security_group" "txcore_poc_sg" {
  name        = "txcore_poc"
  description = "Allow TCP 5000"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "txcore_poc"
  }
}

resource "aws_instance" "txcore_instance" {
  ami           = "ami-0888fe3457b2540bc" # Replace with your actual AMI ID
  instance_type = "t2.micro"
  key_name      = "btstuff"              # Make sure this key exists in your AWS account
  security_groups = [aws_security_group.txcore_poc_sg.name]

  tags = {
    Name = "TxCorePOCInstance"
  }
}
