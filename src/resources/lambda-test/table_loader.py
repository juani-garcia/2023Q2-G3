import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Restaurants')

def lambda_handler(event, context):
    data = json.loads(event['body'])
    id = data['id']
    nombre = data['Nombre']
    
    response = table.put_item(
        Item={
            'id': id,
            'Nombre': nombre
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Data added to DynamoDB successfully')
    }
