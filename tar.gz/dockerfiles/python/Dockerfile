FROM python:3.12-slim-trixie
LABEL maintainer="striveonger@163.com"
LABEL version="1.0.0"

COPY Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt --no-cache-dir \
    && rm -rf /tmp/requirements.txt \
    && pip cache purge
