FROM python:2.7

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV DEMIBOT_SOURCE /usr/src/demibot
COPY . $DEMIBOT_SOURCE
WORKDIR /usr/src/demibot

RUN set -x \
        && pip install --no-cache-dir -r requirements.txt

ENV DEMIBOT_BRAIN_PATH /var/lib/demibot
RUN mkdir -p "$DEMIBOT_BRAIN_PATH" \
        && chown -R user:user "$DEMIBOT_BRAIN_PATH"

VOLUME $DEMIBOT_BRAIN_PATH

COPY ./docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD [ "python", "./bot.py" ]