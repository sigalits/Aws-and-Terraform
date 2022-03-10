resource "aws_lb" "lb" {
  count = var.create_lb ? 1: 0
  name            = "${var.tag_name}-web"
  subnets         = [data.terraform_remote_state.vpc.outputs.public_subnets[*].id]
  security_groups = [data.terraform_remote_state.vpc.outputs.ngnix_sg]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}

# Create a Listener
resource "aws_lb_listener" "my-alb-listener" {
  count = var.create_lb ? 1: 0
  default_action {
    target_group_arn = aws_lb_target_group.target-group[0].arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.lb[0].arn
  port = 80
  protocol = "HTTP"
}


resource "aws_lb_target_group" "target-group" {
  count = var.create_lb ? 1: 0
  name = "ngnix-${var.tag_name}-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.vpc.id
  stickiness {
      type = "lb_cookie"
      cookie_duration = 60
  }
  health_check {
    enabled = true
    path    = "/"
  }
    tags = {
    "name" = "nginx-target-group-${data.aws_vpc.vpc.id}"
  }
}




# restister targset to LB

resource "aws_lb_target_group_attachment" "target_att" {
  count = var.create_lb ? length(local.azs) : 0
  target_group_arn = aws_lb_target_group.target-group[0].arn
  target_id        = module.web-server.web_server[count.index].id
  port             = 80
}
locals {
  subnets=[data.terraform_remote_state.vpc.outputs.public_subnets[*].id]
}


