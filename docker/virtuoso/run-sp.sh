#!/bin/bash
set -e

sleep 10;

if [ ! -f $PWD/.stored_procs_ran ]; then
  isql 1111 dba $VIRTUOSO_DBA_PWD < /tmp/grants.sql
  isql 1111 dba $VIRTUOSO_DBA_PWD < /tmp/create_procesdures.sql
  touch $PWD/.stored_procs_ran
  echo "Stored procs ran"
fi
