module "Network" {
  source = "../NetworkModule"
  vpc_cidr_block = "10.1.0.0/16"
  subnet_cidr_block_1 = "10.1.1.0/24"
  subnet_cidr_block_2 = "10.1.2.0/24"
  subnet_cidr_block_3 = "10.1.3.0/24"
  vpc_name = "Demo"
  subnet_name1 = "sub1"
  subnet_name2 = "sub2"
  subnet_name3 = "sub3"
  security_group_name = "sg"
}

#ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs_cluster_name    
}

resource "aws_ecs_cluster_capacity_providers" "cluster_cp" {
    cluster_name = var.ecs_cluster_name

    capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family = "task_def"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn 
  cpu       = 256
  memory    = 512
  container_definitions = jsonencode([
    {
      name      = "ecs"
      image     = "339712741355.dkr.ecr.us-east-1.amazonaws.com/ecs:latest"

      essential = true
      portMappings = [
        {
          containerPort = 8084
          hostPort      = 8084
        } 
      ]
    }     
  ])
}

# resource "aws_ecs_service" "ecs_service" {
#   name            = "ecs_service"
#   cluster         = var.ecs_cluster_name
#   task_definition = aws_ecs_task_definition.task_def.arn
#   desired_count   = 1
  
#   network_configuration {
#     security_groups    = [module.Network.security_group_id]
#     subnets            = [module.Network.subnet_name2, module.Network.subnet_name3]
#     assign_public_ip = true  
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.ecs_tg.arn
#     container_name = "ecs"
#     container_port = 8084
#   }
# }

# resource "aws_launch_template" "ecs_lt" {
#   name = "ecs_lt"
#   image_id = "ami-0c101f26f147fa7fd"
#   instance_type = "t2.micro"
#   key_name = "ekspem"    
# }

# resource "aws_autoscaling_group" "ecs_asg" {
#  vpc_zone_identifier = [module.Network.subnet_name2, module.Network.subnet_name3]
#  desired_capacity    = 1
#  max_size            = 2
#  min_size            = 1

#  launch_template {
#    id      = aws_launch_template.ecs_lt.id
#    version = "$Latest"
#  }

#  tag {
#    key                 = "AmazonECSManaged"
#    value               = true
#    propagate_at_launch = true
#  }
# }

# resource "aws_lb" "ecs_alb" {
#  name               = "ecs-alb"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [module.Network.security_group_id]
#  subnets            = [module.Network.subnet_name2, module.Network.subnet_name3]
#  tags = {
#    Name = "ecs-alb"
#  }
# }

# resource "aws_lb_listener" "ecs_alb_listener" {
#  load_balancer_arn = aws_lb.ecs_alb.arn
#  port              = 80
#  protocol          = "HTTP"

#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ecs_tg.arn
#  }
# }

# resource "aws_lb_target_group" "ecs_tg" {
#  name        = "ecs-target-group"
#  port        = 8084
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id = module.Network.vpc_id

#  health_check {
#    path = "/hello"
#  }
# }

