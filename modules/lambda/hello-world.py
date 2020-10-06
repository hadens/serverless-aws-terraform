import json
import time

time.ctime()


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
            "time": time.ctime()
        }),
        # "headers":{ 'Access-Control-Allow-Origin' : '*' }
    }
