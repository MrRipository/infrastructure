import json
import os
import uuid
import boto3

dynamodb = boto3.client("dynamodb")
table_name = os.environ["TABLE_NAME"]

def handler(event, context):
    body = json.loads(event["body"])

    item_id = str(uuid.uuid4())

    dynamodb.put_item(
        TableName=table_name,
        Item={
            "id": {"S": item_id},
            "message": {"S": body["message"]}
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "id": item_id,
            "status": "saved"
        })
    }
