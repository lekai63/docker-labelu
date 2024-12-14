# FROM python:3.11-slim

FROM python:3.11-alpine

# 安装必要的构建依赖
RUN apk add --no-cache --virtual .build-deps gcc musl-dev

# 安装labelu
RUN pip install --no-cache-dir labelu && \
    # 删除构建依赖
    apk del .build-deps && \
    # 清理缓存
    rm -rf /root/.cache /tmp/*

# Changed ENV syntax to key=value format
ENV MEDIA_HOST=http://localhost:8000

EXPOSE 8000

CMD ["sh", "-c", "labelu --host=0.0.0.0 --media-host=$MEDIA_HOST"]
