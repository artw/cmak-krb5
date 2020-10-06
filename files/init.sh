/kinit.sh &
bin/cmak \
  -Dconfig.file=conf/application.conf \
  -Dhttp.port=9000 \
  -Dpidfile.path=/dev/null \
  -Djava.security.auth.login.config=/opt/cmak/conf/jaas.conf \
  -Djava.security.krb5.conf=/app/krb5.conf 

#-Dsun.security.krb5.debug=trueu
