resource "aws_ecs_cluster" "demo-cluster" {
  name = "demo-cluster"

  depends_on = [
     aws_autoscaling_group.demo-asg
  ]
}

resource "aws_autoscaling_group" "demo-asg" {
  name                      = "demo-asg"
  launch_configuration      = "aws_launch_configuration.ecs_launch_config.name"
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "EC2"


     depends_on = [
    aws_launch_configuration.ecs_launch_config
]
   }

resource  "aws_launch_configuration" "ecs_launch_config" {
 name           = "ecs_launch_config"
  image_id      = "ami-079b5e5b3971bd10d"
  user_data     = "#!/bin/bash\n echo ECS_CLUSTER=demo-cluster >> /etc/ecs/ecs.config"
 instance_type = "m5.xlarge"

  }








resource "aws_ecs_task_definition" "demo-cluster" {
  family = "demo-cluster"
 container_definitions = jsonencode ([
   {
     name      = "demo-cluster"
     image     = "service-first"

  logconfiguration = {
    logdriver = "awslogs"
    options ={
       awslogs-region = "ap-south-1"
       awslogs-groups = "demo-cluster"
       awslogs-stream-prefix = "ecs"
     }
   }
    cpu       = 10
    memory    = 512
    essential = true
  }
])

 depends_on = [
#   aws_secretsmanager_secret.,
   aws_ecs_cluster.demo-cluster
 ]
}
