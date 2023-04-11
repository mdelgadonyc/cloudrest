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

    return {
        'statusCode': '200',
        'body': json.dumps(event['queryStringParameters'])
    }

    #response = table.get_item(
    #    Key={
    #        'id': dict['id']
    #   }
    #)

    #if 'Item' in response:
    #    return response['Item']
    
    #else:
    #    return {
    #    'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
    #    #'body': 'Record ' + event['id'] + ' added'
    #    'body': 'Not found'
    #    }