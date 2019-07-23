FROM openjdk:8-jre

ENV DWS_ARCHIVE https://github.com/dotwebstack/dotwebstack-theatre-legacy/releases/download
ENV DWS_HOME /usr/share/dotwebstack
ENV DWS_VERSION 0.0.36

RUN set -x \
  && mkdir $DWS_HOME \
  && curl -o $DWS_HOME/dotwebstack.jar -L $DWS_ARCHIVE/v${DWS_VERSION}/dotwebstack-theatre-legacy-${DWS_VERSION}.jar

COPY resources $DWS_HOME

WORKDIR $DWS_HOME

EXPOSE 8080

CMD ["java","-jar","/usr/share/dotwebstack/dotwebstack.jar"]
