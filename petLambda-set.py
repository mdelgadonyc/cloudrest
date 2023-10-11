import boto3
import json
import logging


def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('Pets')

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info('got event{}'.format(event))

    print('event: ', json.dumps(event))
    print('event->body: ', json.dumps(event['body']))

    data = json.loads(event['body'])

    print(data)

    response = table.put_item(
        Item={
            'id': data['id'],
            'name': data['name'],
            'breed': data['breed'],
            'gender': data['gender'],
            'owner': data['owner'],
            'birthday': data['birthday']
        }
    )

    return {

        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Record ' + data['id'] + ' added'
    }
