

resource "aws_vpc" "Demo-Vpc"{
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "production"
  }

}

resource "aws_subnet" "demo-sub" {
  vpc_id     = aws_vpc.Demo-Vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Sub1"
  }
}

resource "aws_internet_gateway" "Demogw" {
  vpc_id = aws_vpc.Demo-Vpc.id

  tags = {
    Name = "productiongw"
  }
}

resource "aws_route_table" "demoroute" {
  vpc_id = aws_vpc.Demo-Vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Demogw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.Demogw.id
  }

  tags = {
    Name = "myroute"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.demo-sub.id
  route_table_id = aws_route_table.demoroute.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Demo-Vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "leader" {
  subnet_id       = aws_subnet.demo-sub.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.leader.id
  associate_with_private_ip = "10.0.1.50"
  depends_on         =         [aws_internet_gateway.Demogw]
}
