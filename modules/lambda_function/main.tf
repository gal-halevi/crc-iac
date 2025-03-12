# Zip backend code to be deployed to lambda function
data "archive_file" "lambda_package" {
  type = "zip"
  source_file = var.source_file_path
  output_path = "index.zip"
}

# Create role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { 
        Service = "lambda.amazonaws.com" 
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS managed policy for allowing CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_role.name
}

# Attach inline custom policy for allowing lambda access for DynamoDB table (for the visitors counter)
resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "dynamodb:UpdateItem",
        ]
        Resource = "${var.dynamodb_table_arn}"
      },
    ]
  })
}

# Create lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  runtime       = "python3.13"
  handler       = "${local.file_stem}.${var.handler}"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}
