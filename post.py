import boto3
import os

# queue name to read from; will be created if it doesn't exist
QUEUE = os.getenv("QUEUE", "sample")

# region queue exists in; defaults to us-east-1
REGION = os.getenv("AWS_DEFAULT_REGION", "us-east-1")

# posts a sample message to the specified queue
#
boto3.setup_default_session(region_name=REGION)
sqs = boto3.resource('sqs')
sqs.create_queue(
    QueueName=QUEUE,
    Attributes={'ReceiveMessageWaitTimeSeconds': '20'}
)
q = sqs.get_queue_by_name(QueueName=QUEUE)
q.send_message(MessageBody='hello world')
