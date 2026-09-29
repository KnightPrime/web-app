terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Open Ports 22 (SSH) and 5000 (Application Port)
resource "aws_security_group" "web_sg" {
  name        = "node-react-sg"
  description = "Allow inbound web traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Narrow down to your IP for safety
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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


# 2. Provision EC2 & Automate Code Setup via User Data
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  #key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Log script output for debugging
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

              echo "Updating system packages..."
              apt-get update -y
              
              echo "Installing Node.js & Git..."
              curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
              apt-get install -y nodejs git
              
              echo "Installing PM2 globally to handle application process management..."
              npm install -g pm2

              echo "Cloning sample application..."
              # REPLACE with your actual public repository URL
              git clone https://github.com /home/ubuntu/app
              
              cd /home/ubuntu/app
              
              echo "Installing dependencies & compiling production files..."
              npm run install-all
              npm run build-client

              echo "Starting backend server with PM2..."
              cd server
              pm2 start index.js --name "node-react-app"
              pm2 save
              pm2 startup
              EOF

  tags = {
    Name = "NodeReactWebServer"
  }
}

output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of your EC2 instance."
}

