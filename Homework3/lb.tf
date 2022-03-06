resource "aws_lb" "lb" {
  name            = "${var.tag_name}-web"
  subnets         = toset(module.vpc.public_subnets[*].id)
  security_groups = [module.web-server.ngnix_sg]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}

# Create a Listener
resource "aws_lb_listener" "my-alb-listener" {
  default_action {
    target_group_arn = aws_lb_target_group.target-group.arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"
}


resource "aws_lb_target_group" "target-group" {
  name = "ngnix-${var.tag_name}-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id
  stickiness {
      type = "lb_cookie"
      cookie_duration = 60
  }
  health_check {
    enabled = true
    path    = "/"
  }
    tags = {
    "name" = "nginx-target-group-${module.vpc.vpc_id}"
  }
}




# restister targset to LB

resource "aws_lb_target_group_attachment" "target_att" {
  count=length(local.azs)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = module.web-server.web_server[count.index].id
  port             = 80
}
locals {
  subnets=[module.vpc.public_subnets]
}


