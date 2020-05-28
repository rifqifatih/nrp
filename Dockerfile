FROM hbpneurorobotics/nrp:dev

COPY docker-entrypoint.sh /usr/local/bin/
COPY nrp-services_app.ini /etc/supervisord.d/
COPY ros-simulation-factory_app.ini /etc/supervisord.d/
COPY rosbridge.ini /etc/supervisord.d/
COPY roscore.ini /etc/supervisord.d/
COPY rosvideo.ini /etc/supervisord.d/
COPY run-experiments.ini_ /etc/supervisord.d/

CMD ["docker-entrypoint.sh"]

EXPOSE 8080
