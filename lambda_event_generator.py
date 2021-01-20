import json
import boto3

def lambda_handler(event, context):
    
    order_details = {
        "orderNumber" : "987654321",
        "productId" : "SSH_1234",
        "otherInfo" : "information",
        "otherObject" : {
            "name" : "Desire Musanze",
            "objectId" : "123456",
            "phrase": "more information about the object"
        }
    }
    
    event_bridge = boto3.client("events")
    
    response = event_bridge.put_events(
        Entries = [
           {
              "Source": "Order Service",
              "DetailType": "New Order",
              "Detail": json.dumps(order_details), 
              "EventBusName" : "ntambiye_bus"
           },
        ]
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
