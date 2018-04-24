FROM python:3
MAINTAINER Matt Ho

RUN pip install boto3 requests
ADD reader.py /lovingly/bin/reader.py

CMD ["/usr/local/bin/python", "/lovingly/bin/reader.py"]
