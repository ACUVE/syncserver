FROM python:2.7-alpine3.7

RUN addgroup -g 1001 app \
    && adduser -u 1001 -S -D -G app -s /usr/sbin/nologin app

ENV LANG C.UTF-8

WORKDIR /app

# install syncserver dependencies
COPY ./requirements.txt /app/requirements.txt
COPY ./dev-requirements.txt /app/dev-requirements.txt
RUN apk --no-cache update \
    && apk add dumb-init libstdc++ g++ \
    && pip install --upgrade pip \
    && pip install --upgrade --no-cache-dir -r requirements.txt \
    && pip install --upgrade --no-cache-dir -r dev-requirements.txt \
    && apk del g++

COPY ./syncserver /app/syncserver
COPY ./setup.py /app
RUN python ./setup.py develop

# run as non priviledged user
USER app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
