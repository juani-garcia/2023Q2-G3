import json
import boto3
client = boto3.client('dynamodb')
def lambda_handler(event, context):
    
    id_value = event['body']['id']['N']
    nombre_value = event['body']['Nombre']['S']
    
    PutItem = client.put_item(
        TableName='Restaurant',
        Item={
            'id': {
              'N': id_value
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