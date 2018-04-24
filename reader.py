import boto3
import requests
import os
import urllib3

# endpoint of http service
ENDPOINT = os.getenv("ENDPOINT", "http://localhost:4000")

# queue name to read from; will be created if it doesn't exist
QUEUE = os.getenv("QUEUE", "sample")

# region queue exists in; defaults to us-east-1
REGION = os.getenv("AWS_DEFAULT_REGION", "us-east-1")


# handle message by posting it to endpoint.  if successful, message will
# be deleted from queue.  otherwise, sqs will retry message.
#
def handle(m):
    try:
        r = requests.post(ENDPOINT, data=m.body)
        if r.status_code == 200:
            m.delete()
            print(f"message processed, [{r.status_code}] {r.reason}")
        else:
            print(f"message rejected, [{r.status_code}] {r.reason}")
    except (urllib3.exceptions.MaxRetryError, requests.exceptions.ConnectionError):
        print(f"unable to post message to endpoint, {ENDPOINT}")
        pass


# main_loop continuously iterates through the queue, reading
#
def main_loop():
    boto3.setup_default_session(region_name=REGION)
    sqs = boto3.resource('sqs')
    q = sqs.get_queue_by_name(QueueName=QUEUE)
    print(f"ENDPOINT: {ENDPOINT}")
    print(f"QUEUE:    {QUEUE}")
    print(f"REGION:   {REGION}")
    print("listening for messages ...")

    while True:
        rs = q.receive_messages(WaitTimeSeconds=20)
        print(f"read {len(rs)} message(s)")
        for m in rs:
            handle(m)


# and away we go
#
main_loop()
