#!/usr/bin/env bash
cp $CATALINA_HOME/webapps/ROOT/WEB-INF/resources/apps/ldt/config.network.xml $CATALINA_HOME/webapps/ROOT/WEB-INF/resources/apps/ldt/config.xml
exec catalina.sh run
