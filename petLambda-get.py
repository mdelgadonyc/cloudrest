import boto3
import json
import logging

def lambda_handler(event, context):

    client = boto3.resource('dynamodb')

    table = client.Table('Pets')

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info('got event{}->queryStringParameters'.format(event['queryStringParameters']))

    
    #dict = json.loads(event['body'])
    #dict = json.loads(event['queryStringParameters'])
    print('event->queryStringParameters: ', json.dumps(event['queryStringParameters']))
    dbID = json.dumps(event['queryStringParameters']["id"])
    print(dbID)

    response = table.get_item(
        Key={
            #'id': dbID
            'id':'31337'
       }
    )

    if 'Item' in response:
        print(response['Item'])
        return {
            #'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
            "statusCode": "200",
            "body": "response['Item']"
        } 
    else:
        return {
            'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
            'body': 'Not found'
        }
    