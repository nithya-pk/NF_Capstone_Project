# Autoscaling Group for backend
resource "aws_autoscaling_group" "asg_be" {
 name = "asg_be"
 launch_template {id = aws_launch_template.be_server.id}
 min_size = 2
 max_size = 6
 desired_capacity = 2
 vpc_zone_identifier = aws_subnet.private_subnets_be_db[*].id
 health_check_type = "EC2"
 tag {
  key = "Name"
  value = "be_server"
  propagate_at_launch = true
 } 
}

# Scale up policy
resource "aws_autoscaling_policy" "be_scaleup_policy" {
 name = "be_scaleup_policy"
 policy_type = "SimpleScaling"
 adjustment_type = "ChangeInCapacity"
 autoscaling_group_name = aws_autoscaling_group.asg_be.name
 scaling_adjustment = 1
 cooldown = 300 # seconds
}

# Scale up alarm
resource "aws_cloudwatch_metric_alarm" "be_scale_up_alarm" {
 alarm_name = "be_scale_up_alarm"
 comparison_operator = "GreaterThanOrEqualToThreshold"
 evaluation_periods = "2"
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = "120"
 statistic = "Average"
 threshold = "70"
 alarm_description = "Scale up if CPU exceeds 70% for 2 minutes"
 dimensions = {AutoScalingGroupName = aws_autoscaling_group.asg_be.name}
 alarm_actions = [aws_autoscaling_policy.be_scaleup_policy.arn]
}

# Scale down policy
resource "aws_autoscaling_policy" "be_scale_down_policy" {
 name = "be_scale_down_policy"
 policy_type = "SimpleScaling"
 adjustment_type = "ChangeInCapacity"
 autoscaling_group_name = aws_autoscaling_group.asg_be.name
 scaling_adjustment = -1
 cooldown = 300 # seconds
}

# Scale down alarm
resource "aws_cloudwatch_metric_alarm" "be_scale_down_alarm" {
 alarm_name = "be_scale_down_alarm"
 comparison_operator = "LessThanOrEqualToThreshold"
 evaluation_periods = "5"
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = "300"
 statistic = "Average"
 threshold  = "30"
 alarm_description = "Scale down if CPU is below 30% for 5 minutes"
 dimensions = {AutoScalingGroupName = aws_autoscaling_group.asg_be.name}
 alarm_actions = [aws_autoscaling_policy.be_scale_down_policy.arn]
}