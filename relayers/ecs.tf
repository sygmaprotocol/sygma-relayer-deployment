resource "aws_ecs_cluster" "main" {
  name = "relayer-${var.app_tag}"
  tags = {
    Name = "relayer-${var.app_tag}"
  }
}

resource "aws_ecs_task_definition" "main" {
  count = var.relayers
  network_mode             = "awsvpc"
  family                   = "${var.project_name}-${count.index}-container-${var.app_tag}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_cpu_usage
  memory                   = var.app_memory_usage
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-${count.index}-container-${var.app_tag}"
      image     = "${var.app_image}:${var.app_tag}"
      cpu       = var.app_cpu_usage
      memory    = var.app_memory_usage
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.app_container_port
          hostPort      = var.app_container_port
        },
        {
          protocol      = "tcp"
          containerPort = 9001
          hostPort      = 9001
        }
      ]
    }
  ])

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_service" "main" {
  count = var.relayers
  name                               = "${var.project_name}-${count.index}-service-${var.app_tag}"
  cluster                            = aws_ecs_cluster.main.id
  desired_count                      = 1
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = 200
  task_definition                    = aws_ecs_task_definition.main.arn
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  service_registries {
    registry_arn   = aws_service_discovery_service.ecs-service-discovery[count.index].arn
    container_name = "${var.project_name}-${count.index}-container-${var.app_tag}"
  }
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnets.ec2_private_subnets.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tcp[count.index].arn
    container_name   = "${var.project_name}-${count.index}-container-${var.app_tag}"
    container_port   = var.app_container_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.http[count.index].arn
    container_name   = "${var.project_name}-${count.index}-container-${var.app_tag}"
    container_port   = "9001"
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_service_discovery_private_dns_namespace" "ecs-service-namespace" {
  name        = "${var.project_name}-${var.app_tag}"
  description = "${var.project_name} ${var.app_tag} namespace"
  vpc         = data.aws_vpc.vpc.id
}
resource "aws_service_discovery_service" "ecs-service-discovery" {
  count = var.relayers
  name = "${var.project_name}-${count.index}"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs-service-namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  count = var.relayers
  max_capacity       = var.app_max_capacity
  min_capacity       = 1
  resource_id        = "service/arn:aws:ecs:us-east-2:852551629426:cluster/relayer-STAGE/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count = var.relayers
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count = var.relayers
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60
  }
}