FROM python:3.11-slim

RUN pip3 install labelu

# Changed ENV syntax to key=value format
ENV MEDIA_HOST=http://localhost:8000

EXPOSE 8000

CMD ["sh", "-c", "labelu --host=0.0.0.0 --media-host=$MEDIA_HOST"]
