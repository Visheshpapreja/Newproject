resource "aws_lb_target_group" "TG-lb" {
  name     = "TG-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Demo-Vpc.id 
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
