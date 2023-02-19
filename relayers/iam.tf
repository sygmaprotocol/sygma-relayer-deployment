resource "aws_iam_role" "ecs_task_role" {
  count = var.relayers
  name = "${var.project_name}-${count.index}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "task_policy" {
  count = var.relayers
  name        = "${var.project_name}-${count.index}-task-policy"
  path        = "/"
  description = "Task App policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter*",
          "ssm:DescribeParameters",
          "kms:Decrypt",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  count = var.relayers
  role       = aws_iam_role.ecs_task_role[count.index].name
  policy_arn = aws_iam_policy.task_policy[count.index].arn
}

###
# ECS Service Role
###

resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.relayers
  name = "${var.project_name}-${count.index}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  count = var.relayers
  role       = aws_iam_role.ecs_task_execution_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-ssm-role-policy-attachment" {
  count = var.relayers
  role       = aws_iam_role.ecs_task_execution_role[count.index].name
  policy_arn = aws_iam_policy.task_policy[count.index].arn
}