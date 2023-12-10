import json
import boto3
import uuid

# Generar un UUIDv4 para el ID del restaurante
id_restaurante = str(uuid.uuid4())

client = boto3.client('dynamodb')
def lambda_handler(event, context):
    
    nombre_value = event['body']['Nombre']
    
    PutItem = client.put_item(
        TableName='Restaurant',
        Item={
            'id': {
              'S': id_restaurante
            },
            'Nombre': {
              'S': nombre_value
            }
        }
      )
    response = {
      'statusCode': 200,
      'body': json.dumps('Data added to DynamoDB successfully')
    }
    return response
