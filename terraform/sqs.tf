resource "aws_sqs_queue" "dirt_alert_queue" {
  name = "DirtAlertQueue"
  max_message_size = 2048
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dirt_alert_deadletter.arn
    maxReceiveCount = 4
  })
}
resource "aws_sqs_queue" "dirt_alert_deadletter" {
  name = "DirtAlertDeadletter"
}

resource "aws_sqs_queue_redrive_allow_policy" "dirt_alert_deadletter_redrive" {
  queue_url = aws_sqs_queue.dirt_alert_deadletter.id

  redrive_allow_policy =  jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns = [aws_sqs_queue.dirt_alert_queue.arn]
  })
}    
