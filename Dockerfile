FROM hbpneurorobotics/nrp:dev

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["docker-entrypoint.sh"]

EXPOSE 8080
