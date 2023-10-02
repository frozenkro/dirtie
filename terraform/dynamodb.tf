resource "aws_dynamodb_table" "dirt_alerts_table" {
  name = "DirtAlerts"
  hash_key = "DeviceId"
  range_key = "Timestamp"

  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "DeviceId"
    type = "S"
  }
  attribute {
    name = "Timestamp"
    type = "N"
  }
}

