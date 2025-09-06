# EDA + Bedrock (SQS -> Lambda)
## Despliegue
aws cloudformation deploy --template-file cfn/stack.yml --stack-name eda-bedrock --capabilities CAPABILITY_NAMED_IAM
## Prueba
aws sqs send-message --queue-url <QueueUrl> --message-body "Hola, quiero un resumen"
## Logs
aws logs tail /aws/lambda/eda-bedrock-consumer --follow
