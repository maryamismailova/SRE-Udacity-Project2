resource "aws_instance" "ubuntu" {
  ami           = var.aws_ami
  count         = var.instance_count 
  instance_type = var.instance_type
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = var.tags
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow all on port 80"
    protocol = "tcp"
    from_port = 1
    to_port = 80
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow all on port 22"
    protocol    = "tcp"
    from_port = 1
    to_port = 22
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow all out"
    protocol    = -1
    from_port = 0
    to_port = 0
  }

  tags = var.tags
}