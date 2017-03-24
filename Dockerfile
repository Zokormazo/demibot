FROM python:2.7-alpine

ENV GOSU_VERSION 1.10
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps \
    && addgroup -g 1000 user \
    && adduser -G user -u 1000 -D user

ENV DEMIBOT_SOURCE /usr/src/demibot
ENV DEMIBOT_BRAIN_PATH /var/lib/demibot

COPY . $DEMIBOT_SOURCE
WORKDIR /usr/src/demibot

RUN set -x \
    && apk add --no-cache build-base --virtual .build-base \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-base \
    && mkdir -p "$DEMIBOT_BRAIN_PATH" \
    && chown -R user:user "$DEMIBOT_BRAIN_PATH"

VOLUME $DEMIBOT_BRAIN_PATH

ENTRYPOINT ["/usr/src/demibot/docker-entrypoint.sh"]

CMD [ "python", "./bot.py" ]
