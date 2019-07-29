FROM tomcat:7-jdk8-openjdk

ENV LDT_ARCHIVE https://github.com/architolk/Linked-Data-Theatre/releases/download
ENV LDT_VERSION 1.23.0

RUN set -x \
  && rm -rf $CATALINA_HOME/webapps/* \
  && mkdir $CATALINA_HOME/webapps/ROOT \
  && curl -o /tmp/ldt.war -L $LDT_ARCHIVE/v${LDT_VERSION}/ldt-${LDT_VERSION}.war \
  && unzip /tmp/ldt.war -d $CATALINA_HOME/webapps/ROOT \
  && rm /tmp/ldt.war

WORKDIR $CATALINA_HOME/webapps

COPY WEB-INF/ ROOT/WEB-INF/

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["catalina.sh","run"]
