resource "aws_sqs_queue" "dirt_alert_queue" {
  name = "DirtAlertQueue"
  max_message_size = 2048
  redrive_policy = jsondecode({
    deadLetterTargetArn = aws_sqs_queue.dirt_alert_deadletter.arn
    maxReceiveCount = 4
  })
}
resource "aws_sqs_queue" "dirt_alert_deadletter" {
  name = "DirtAlertDeadletter"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns = [aws_sqs_queue.dirt_alert_queue.arn]
  })
}
