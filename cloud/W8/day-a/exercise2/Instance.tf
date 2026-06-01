resource "aws_instance" "example" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = "ap-southeast-1a"

  tags = {
    Name    = "Dove-web"
    Project = "Dove"
  }
}

resource "aws_ec2_instance_state" "web-state" {
    instance_id = aws_instance.example.id
    state       = "running"
}
