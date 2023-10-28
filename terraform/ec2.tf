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
}

resource "aws_instance" "mosquitto_server" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id

  user_data = <<-EOF
    #!/bin/bash
    apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
    apt-get update -y
    EOF

  user_data_replace_on_change = true

  tags = {
    Name = "dirtie-mqtt-broker"
  }
}
