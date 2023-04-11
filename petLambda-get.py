import boto3
import json
import logging

def lambda_handler(event, context):

    client = boto3.resource('dynamodb')

    table = client.Table('Pets')

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info('got event{}->queryStringParameters'.format(event['queryStringParameters']))

    print('event->queryStringParameters: ', json.dumps(event['queryStringParameters']))
    
    dbID = json.dumps(event['queryStringParameters']["id"])
    dbID = dbID.replace('"', "")    # remove the literal quotation marks around our ID.
    
    response = table.get_item(
        Key={            
            'id': dbID
        }
    )

    bodyStr = ""

    if 'Item' in response:
        print(response['Item'])
        bodyStr = json.dumps(response['Item'])
    else:
        bodyStr = 'Not found.'
    
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        "body": bodyStr
    }


'''
        return {
            'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
            "body": json.dumps(response['Item'])
        } 
    else:
        return {
            'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
            'body': 'Not found'
        }
'''
    