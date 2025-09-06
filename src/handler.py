import json, os, boto3
bedrock = boto3.client("bedrock-runtime")

def lambda_handler(event, context):
    for r in event.get("Records", []):
        body = r.get("body","")
        prompt = f"Resume en una línea: {body}"
        model_id = os.getenv("MODEL_ID","amazon.titan-text-lite-v1")
        resp = bedrock.invoke_model(modelId=model_id, body=json.dumps({"inputText": prompt}))
        out = json.loads(resp["body"].read())
        print("BEDROCK_OUTPUT:", out)
    return {"statusCode": 200, "body": "ok"}
