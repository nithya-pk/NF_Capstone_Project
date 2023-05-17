#Create an application load balancer for front end servers
resource "aws_alb" "FEalb" {
name = "FEalb"
internal = false
load_balancer_type = "application"
security_groups = [aws_security_group.allow_tcp_alb.id]
subnets = aws_subnet.public_subnets.*.id
tags = {Name = "FEalb"}
}

#Create Target Group
resource "aws_alb_target_group" "albTG" {
 name = "albTG"
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.NK_VPC.id
 health_check {
  interval = 30
  port = 80
  protocol = "HTTP"
  healthy_threshold = 5
  unhealthy_threshold = 2
  timeout = 5
  path = "/"
  matcher = "200,202"
 }

#  http2_health_check {
#   interval = 30
#   port = 443
#   protocol = "HTTPS"
#   healthy_threshold = 5
#   unhealthy_threshold = 2
#   timeout = 5
#   path = "/"
#   matcher = "200,202"
#  }
 tags = {Name = "alb-fe-tg"}
}

#Listener for Load Balancer
resource "aws_alb_listener" "albLSNR" {
 load_balancer_arn = "${aws_alb.FEalb.arn}"
 port = 80
 protocol = "HTTP"
 default_action {
  target_group_arn = "${aws_alb_target_group.albTG.arn}"
  type = "redirect"
  redirect {
   port = "443"
   protocol = "HTTPS"
   status_code = "HTTP_301"
  }
 }
}
