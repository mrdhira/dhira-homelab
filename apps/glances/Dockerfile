FROM nicolargo/glances:latest-full
COPY glances.conf /glances/conf/glances.conf
CMD python -m glances -C ../../config//glances/glances.conf $GLANCES_OPT
