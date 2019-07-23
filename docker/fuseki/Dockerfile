# Inspired by: https://github.com/stain/jena-docker/blob/master/jena-fuseki/Dockerfile

FROM openjdk:8-jre

ENV FUSEKI_ARCHIVE https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki
ENV FUSEKI_VERSION 3.10.0
ENV FUSEKI_HOME /usr/share/fuseki
ENV FUSEKI_BASE /fuseki

RUN set -x \
  && curl -o /tmp/fuseki.tar.gz -L $FUSEKI_ARCHIVE-$FUSEKI_VERSION.tar.gz \
  && tar zxf /tmp/fuseki.tar.gz -C /tmp \
  && mv /tmp/apache-jena-fuseki-$FUSEKI_VERSION $FUSEKI_HOME \
  && rm /tmp/fuseki.tar.gz \
  && rm -rf $FUSEKI_HOME/fuseki.war

VOLUME $FUSEKI_BASE

WORKDIR $FUSEKI_HOME

EXPOSE 3030

CMD ["/usr/share/fuseki/fuseki-server"]
