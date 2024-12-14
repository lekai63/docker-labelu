FROM python:3.11-slim as builder

# Version numbers as build args
ARG FRONTEND_VERSION
ARG BACKEND_VERSION

RUN rm /etc/apt/sources.list.d/debian.sources

RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list

RUN echo $BACKEND_VERSION

RUN apt-get update && apt-get install -y wget unzip

WORKDIR /labelu

COPY . .

# Construct frontend URL from version
RUN wget https://github.com/opendatalab/labelU-Kit/releases/download/v${FRONTEND_VERSION}/frontend.zip -O frontend.zip && \
    unzip frontend.zip && \
    cp -r dist/* labelu/internal/statics/ && \
    rm frontend.zip

RUN pip install poetry -i https://mirrors.aliyun.com/pypi/simple/ && \
    poetry source add --priority=default mirrors https://mirrors.aliyun.com/pypi/simple/ && \
    poetry build

ENV BACKEND_VERSION=$BACKEND_VERSION

FROM python:3.11-slim

ARG BACKEND_VERSION
ENV BACKEND_VERSION=$BACKEND_VERSION

WORKDIR /labelu

COPY --from=builder /labelu/dist/labelu-${BACKEND_VERSION}-py3-none-any.whl .

RUN pip3 install labelu-${BACKEND_VERSION}-py3-none-any.whl -i https://mirrors.aliyun.com/pypi/simple/ && \
    rm labelu-${BACKEND_VERSION}-py3-none-any.whl

# You can set the media host to your own host
ENV MEDIA_HOST http://localhost:8000

EXPOSE 8000

CMD ["sh", "-c", "labelu --host=0.0.0.0 --media-host=$MEDIA_HOST"]
