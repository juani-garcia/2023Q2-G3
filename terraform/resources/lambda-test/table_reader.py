import json
import boto3

def lambda_handler(event, context):
    client = boto3.client('dynamodb', region_name='us-east-1')
    
    restaurant = {
        'message': 'Mocked'
    }
    
    restaurant = client.get_item(
        TableName='Restaurant',
        Key={'id': {'N': '0'}}
    ).get('Item', None)
    
    return {
        'statusCode': 200,
        'body': restaurant
    }