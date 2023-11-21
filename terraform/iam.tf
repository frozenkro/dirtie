### Define Lambda execution role
resource "aws_iam_role" "lambda_exec_role" {
    name = "dirtie_lambda_exec_role"
    description = "Execution role for lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}


### Attach policies to role
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
    role = aws_iam_role.lambda_exec_role.id
    policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
    role = aws_iam_role.lambda_exec_role.id
    policy_arn = aws_iam_policy.dynamodb_lambda.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
    role = aws_iam_role.lambda_exec_role.id
    policy_arn = data.aws_iam_policy.allow_sqs_lambda.arn
}


### Define policies or retrieve aws-managed policies
# Assume Role policy (attached in role resource definition)
data "aws_iam_policy_document" "assume_lambda_role" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

# Cloudwatch logging policy
data "aws_iam_policy_document" "allow_lambda_logging" {
    statement {
        effect = "Allow"
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]

        resources = [
            "arn:aws:logs:*:*:*",
        ]
    }
}
resource "aws_iam_policy" "lambda_logging" {
    name = "AllowLambdaLogging"
    description = "Policy for lambda cloudwatch logging"
    policy = data.aws_iam_policy_document.allow_lambda_logging.json
}

# DynamoDB read/update policy
data "aws_iam_policy_document" "allow_dynamodb_lambda" {
    statement {
        effect = "Allow"
        actions = [
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
            "dynamodb:GetItem",
            "dynamodb:GetRecords",
            "dynamodb:Query",
            "dynamodb:Scan"
        ]
        resources = [
            aws_dynamodb_table.dirt_alerts_table.arn
        ]
    }
}
resource "aws_iam_policy" "dynamodb_lambda" {
    name = "AllowDynamoDBLambda"
    description = "Policy for lambdas to read and update dynamodb"
    policy = data.aws_iam_policy_document.allow_dynamodb_lambda.json
}

# SQS Execution Role policy (just using the aws-managed one)
data "aws_iam_policy" "allow_sqs_lambda" {
    name = "AWSLambdaSQSQueueExecutionRole"
}
