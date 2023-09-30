resource "aws_cloudwatch_log_group" "dirtie_log_group" {
  name = "/aws/lambda/${aws_lambda_function.postdirtalert_function.function_name}"
  retention_in_days = 14
}
