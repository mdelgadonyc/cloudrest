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

    dict = json.loads(event['body'])

# Python AWS Lambda's event body returning string instead of my json object
# https://stackoverflow.com/questions/70352258/python-aws-lambdas-event-body-returning-string-instead-of-my-json-object

    
    # Insomnia (JSON) entered: {"id": "31337", "name": "hashpuppy", "breed": "elite", "gender": "male", "owner": "neo", "birthday": "101011"}
    
    print(dict)
    
    response = table.put_item(
        Item = {
            'id': dict['id'],
            'name': dict['name'],
            'breed': dict['breed'],
            'gender': dict['gender'],
            'owner': dict['owner'],
            'birthday': dict['birthday']
        }
    )

    return {

        'statusCode': 200,
        'body': json.dumps(dict)
        # 'body': json.dumps(event['id']) # returning the data sent to backend lambada function as API response

        #'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        #'body': 'Record ' + event['id'] + ' added'
    }