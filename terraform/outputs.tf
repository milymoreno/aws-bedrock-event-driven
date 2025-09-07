output "queue_url" { value = aws_sqs_queue.app.id }
output "queue_arn" { value = aws_sqs_queue.app.arn }
output "lambda_name" { value = aws_lambda_function.app.function_name }
