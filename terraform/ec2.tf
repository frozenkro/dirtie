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

data "aws_key_pair" "mosquitto_server_key" {
  key_name = var.MOSQUITTO_INST_KEY_NAME
  include_public_key = true
}

resource "aws_security_group" "mqtt_ssh" {
  name = "allow_all_mqtt_ssh"
  description = "Allows all mqtt traffic as well as secure shell"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "MQTT Unencrypted"
    from_port = 1883
    to_port = 1883
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "MQTT Encrypted"
    from_port = 8883
    to_port = 8883
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "MQTT websocket Unencrypted"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "MQTT websocket Encrypted"
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "mosquitto_server" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id
  key_name = data.aws_key_pair.mosquitto_server_key.key_name
  security_groups = [aws_security_group.mqtt_ssh.name]

  user_data = <<-EOF
    #!/bin/bash
    apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
    apt-get update -y
    apt-get install mosquitto mosquitto-clients -y
    echo listener 1883 >> /etc/mosquitto/mosquitto.conf
    echo listener 8883 >> /etc/mosquitto/mosquitto.conf
    echo allow_anonymous true >> /etc/mosquitto/mosquitto.conf
    sudo systemctl start mosquitto
    EOF

  user_data_replace_on_change = true

  tags = {
    Name = "dirtie-mqtt-broker"
  }
}
