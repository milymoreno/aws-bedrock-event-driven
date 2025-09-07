# Empaquetar Lambda desde ../src/handler.py
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/handler.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_sqs_queue" "app" {
  name                       = var.queue_name
  visibility_timeout_seconds = 60
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "inline" {
  name = "${var.lambda_name}-inline"
  role = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:ChangeMessageVisibility"],
        Resource = aws_sqs_queue.app.arn
      },
      {
        Effect   = "Allow",
        Action   = ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "app" {
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.12"
  handler          = "handler.lambda_handler"
  timeout          = var.lambda_timeout
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment {
    variables = {
      MODEL_ID = var.model_id
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.app.arn
  function_name    = aws_lambda_function.app.arn
  batch_size       = 1
  enabled          = true
}
