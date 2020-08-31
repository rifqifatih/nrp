FROM hbpneurorobotics/nrp:dev

RUN pip install torch==1.4.0 && \
    pip install torchvision==0.5.0 && \
    pip install future==0.18.2 && \
    pip install selectors2==2.0.1

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["docker-entrypoint.sh"]

EXPOSE 8080
