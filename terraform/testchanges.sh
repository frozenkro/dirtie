terraform plan -out=./tfplan --profile Admin
terraform apply "./tfplan"
aws sqs send-message --profile Admin --queue-url https://sqs.us-east-2.amazonaws.com/827360054415/DirtAlertQueue --message-body {"deviceId":"testDeviceCli","timestamp":323456789,"level":5.534}
