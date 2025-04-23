import json
import boto3

db = boto3.resource('dynamodb')
table = db.Table('My_Cloud_Resume_Table')

def lambda_handler(event, context):
    print("EVENT:", json.dumps(event))
    response = table.get_item(
        Key={
            'id': '1'
        }
    )

    views = response['Item']['views']
    views += 1
    print(views)

    response = table.put_item(
        Item={
            'id': '1',
            'views': views
        }
    )

    return views

