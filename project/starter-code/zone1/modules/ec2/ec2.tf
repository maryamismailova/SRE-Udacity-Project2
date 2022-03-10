resource "aws_instance" "ubuntu" {
  ami           = var.aws_ami
  count = var.instance_count
  instance_type = "t3.micro"
  key_name = "udacity"
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Ubuntu-Web"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  vpc_id      = var.vpc_id

  ingress {    
    description = "web port"
    from_port   = 80    
    to_port     = 80
    protocol    = "tcp"    
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh port"
    from_port   = 22    
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "monitoring"
    from_port   = 9100    
    to_port     = 9100
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
    Name = "ec2_sg"
  }
}

resource "null_resource" "update_public_ip" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    working_dir = var.project_root_directory
    command = "cat prometheus-additional-template.yaml  | sed \"s/PUBLIC_IP/${aws_instance.ubuntu.0.public_ip}/g\" > prometheus-additional.yaml "
  }
}