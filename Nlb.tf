resource "aws_lb" "My-lb" {
  name               = "My-lb"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = aws_subnet.demo-sub.id
    private_ipv4_address = "10.0.1.50"
  }

  subnet_mapping {
    subnet_id            = aws_subnet.demo-sub.id
    private_ipv4_address = "10.0.1.50"
  }
}
