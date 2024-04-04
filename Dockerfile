FROM consul:1.15.4

COPY ./app /template
COPY dockerscripts/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

COPY .env /run/secrets/env

# сделать файл исполняемым
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
