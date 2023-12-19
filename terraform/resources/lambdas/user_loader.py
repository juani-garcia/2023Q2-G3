import json
import boto3
import uuid

# Generar un UUIDv4 para el ID del restaurante
id_user = str(uuid.uuid4())

client = boto3.client('dynamodb')
def lambda_handler(event, context):
    
    nombre_value = event['body']['Nombre']
    email_value = event['body']['Email']
    
    PutItem = client.put_item(
        TableName='User',
        Item={
            'id': {
              'S': id_user
            },
            'Nombre': {
              'S': nombre_value
            },
            'Email': {
              'S': email_value
            }
        }
      )
    response = {
      'statusCode': 200,
      'body': json.dumps('Data added to DynamoDB successfully')
    }
    return response
