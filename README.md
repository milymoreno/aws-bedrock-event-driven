
# Microservicio Event-Driven con AWS Bedrock, SQS, Lambda y Monitoreo

Este proyecto implementa una arquitectura event-driven en AWS, integrando procesamiento de eventos con IA (Amazon Bedrock), colas SQS, funciones Lambda y monitoreo con CloudWatch.

## Arquitectura

![Arquitectura](C4/Imagen%20pegada.png)

La arquitectura se compone de los siguientes elementos:

- **Amazon API Gateway**: Punto de entrada para aplicaciones frontend o servicios externos que envían eventos.
- **EC2 Microservice**: Servicio backend opcional que también puede enviar eventos a la cola.
- **Amazon SQS (Event Queue)**: Cola de eventos que almacena mensajes con prompts para procesar.
- **AWS Lambda (eda-bedrock-consumer)**: Función que consume mensajes de SQS, invoca el modelo de IA en Bedrock y envía logs a CloudWatch.
- **Amazon Bedrock**: Servicio de IA generativa, utilizado aquí con el modelo Titan Text G1 Lite para enriquecer los eventos.
- **Amazon CloudWatch**: Monitoreo y registro de logs y métricas generados por la función Lambda.

### Flujo de eventos

1. **Productores** (API Gateway, EC2) envían mensajes (JSON con prompt) a la cola SQS.
2. SQS activa la función Lambda cuando hay mensajes disponibles.
3. Lambda procesa el mensaje, invoca el modelo de Bedrock y obtiene la respuesta de IA.
4. Lambda registra logs y métricas en CloudWatch.

## Despliegue

Puedes desplegar la arquitectura usando CloudFormation (`cfn/stack.yml`). También se incluye una versión en Terraform (`terraform/`).

### CloudFormation

```bash
aws cloudformation deploy \
	--template-file cfn/stack.yml \
	--stack-name eda-bedrock-stack \
	--capabilities CAPABILITY_NAMED_IAM
```

### Terraform

```bash
cd terraform
terraform init
terraform apply
```

## Prueba

```bash
aws sqs send-message --queue-url <QueueUrl> --message-body "Hola, quiero un resumen"
```

## Logs

```bash
aws logs tail /aws/lambda/eda-bedrock-consumer --follow
```

## Código Lambda

El código de la función Lambda está embebido en la plantilla CloudFormation y también disponible en `src/handler.py` y `terraform/lambda_src/handler.py`.

## Personalización

- Cambia el modelo de Bedrock en la variable de entorno `MODEL_ID`.
- Ajusta el timeout de Lambda y el nombre de la cola SQS en los parámetros de la plantilla.

## Requisitos

- AWS CLI configurado
- Permisos para crear roles IAM, SQS, Lambda, Bedrock y CloudWatch

## Referencias

- [Documentación oficial de AWS Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/)
- [PlantUML AWS Icons](https://github.com/awslabs/aws-icons-for-plantuml)

---

> Diagrama generado con PlantUML (`C4/arquitectura.puml`).
