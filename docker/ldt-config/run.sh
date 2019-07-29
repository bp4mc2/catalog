#!/usr/bin/env bash
cd /usr/share/config
curl -X PUT -T default.ttl http://virtuoso:8890/sparql-graph-crud?graph-uri=http://localhost/stage
