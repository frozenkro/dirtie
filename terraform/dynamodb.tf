resource "aws_dynamodb_table" "dirt_alerts_table" {
  name = "DirtAlerts"
  hash_key = "DeviceId"
  range_key = "Timestamp"

  attribute {
    name = "DeviceId"
    type = "S"
  }
  attribute {
    name = "Timestamp"
    type = "N"
  }
  attribute {
    name = "Level"
    type = "N"
  }
}

