import json

def lambda_handler(event, context):
    name = event['queryStringParameters']['name'] if 'name' in event['queryStringParameters'] else "" # TODO: if validation is not working as intended
    name = name if name != "" else "World" 
    res = "Hello " + name + "!"
    response = {
        "statusCode": 200,
        "body": json.dumps({'message': res}),
    }
    return response

## Previous:

# def lambda_handler(event, context):
#     # Extracting the value from the request, assuming it's in the query parameters
#     value = event["value"]

#     # Creating the response body
#     body = {
#         "message": f"Hello {value}!"
#     }

#     # Returning the response with HTTP status code 200
#     response = {
#         "statusCode": 200,
#         "body": json.dumps(body),
#         "headers": {
#             "Content-Type": "application/json",
#             "Access-Control-Allow-Origin": "*"  # Enable CORS for all domains
#         }
#     }

#     return response


# import json

# def lambda_handler(event, context):
#     payload = event
#     payload = payload["Records"][0]
#     body = payload["body"]
#     body = body.replace('\n', '')
#     body = json.loads(body)
#     # body = json.loads(event['body'])
#     # message = 'Hello {}!'.format(body['key1'])
#     resp = {
# 		"statusCode": 200,
# 		"headers": {
# 			"Access-Control-Allow-Origin": "*",
# 		},
# 		"body": ("Hello " + body["key1"] + "!")
# 	}
#     # return {
#     #     'message' : message
#     # }
#     return resp