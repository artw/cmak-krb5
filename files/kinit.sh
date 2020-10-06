#!/bin/sh -x
_KINIT=${KINIT:-/usr/bin/kinit}
_PRINC=${KINIT_PRINCIPAL}
_KEYTAB=${KINIT_KEYTAB}
_TGT_LIFE=${KINIT_LIFETIME:-10h}
_TGT_RENEW=${KINIT_RENEWABLE_LIFE:-7d}
_SLEEP=${KINIT_RENEW_SLEEP:-60}
_KINIT_CMD="${_KINIT} -l ${_TGT_LIFE} -r ${_TGT_RENEW} -kt ${_KEYTAB} ${_PRINC}"

# kinit or die
$_KINIT_CMD || exit 1

while true 
do
  sleep $_SLEEP;
  # renew, reinit or die
  $_KINIT -R || $_KINIT_CMD || exit 1 
done
