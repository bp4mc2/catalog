FROM openjdk:8-jre

ENV DWS_VERSION 0.0.36

RUN set -x \
  && mkdir /usr/share/dotwebstack \
  && curl -o /usr/share/dotwebstack/dotwebstack.jar -L https://github.com/dotwebstack/dotwebstack-theatre-legacy/releases/download/v${DWS_VERSION}/dotwebstack-theatre-legacy-${DWS_VERSION}.jar

COPY resources /usr/share/dotwebstack

WORKDIR /usr/share/dotwebstack

CMD ["java","-jar","/usr/share/dotwebstack/dotwebstack.jar"]

EXPOSE 8080
