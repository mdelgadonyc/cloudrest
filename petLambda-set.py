import boto3

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('Pets')

    response = table.put_item(
        Item = {
            'id': event['id'],
            'name': event['name'],
            'breed': event['breed'],
            'gender': event['gender'],
            'owner': event['owner'],
            'birthday': event['birthday']
        }
    )

    return {

        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Record ' + event['id'] + ' added'
    }