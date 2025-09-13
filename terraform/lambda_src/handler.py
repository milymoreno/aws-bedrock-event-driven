import json
import boto3
import os

bedrock = boto3.client(service_name="bedrock-runtime", region_name=os.environ.get("AWS_REGION", "us-east-1"))

def lambda_handler(event, context):
    try:
        print("EVENTO RECIBIDO:", event)
        
        # Mensaje desde SQS
        message = event["Records"][0]["body"]
        prompt = f"Genera un resumen breve sobre: {message}"

        # Llama al modelo Titan en Bedrock
        model_id = "amazon.titan-text-lite-v1"
        resp = bedrock.invoke_model(
            modelId=model_id,
            body=json.dumps({"inputText": prompt})
        )

        result = json.loads(resp["body"].read())
        output = result["results"][0]["outputText"]

        print("BEDROCK OUTPUT:", output)

        return {
            "statusCode": 200,
            "body": json.dumps({"response": output})
        }

    except Exception as e:
        print("ERROR:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
