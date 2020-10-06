FROM debian:buster

ENV SCALA_VERSION=2.12.10 SBT_VERSION=1.3.8 CMAK_VERSION=3.0.0.5

RUN set -xe \
    && apt-get update \
    && apt-get install -y openjdk-11-jre-headless curl wget krb5-user \
    && wget -q https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.deb -O scala.deb \
    && wget -q https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb -O sbt.deb \
    && dpkg -i scala.deb sbt.deb \
    && rm scala.deb sbt.deb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/cmak

RUN set -xe \
    && mkdir src \
    && curl -sSL https://github.com/yahoo/CMAK/archive/$CMAK_VERSION.tar.gz | tar xz --strip 1 -C src \
    && cd src \
    && sbt clean universal:packageZipTarball \
    && cd .. \
    && tar xzf src/target/universal/cmak-$CMAK_VERSION.tgz --strip 1 \
    && rm -rf src

#VOLUME /opt/cmak/conf

EXPOSE 9000

#HEALTHCHECK CMD curl -f http://127.0.0.1/api/health || exit 1

ADD files/init.sh files/kinit.sh /
ADD files/jaas.conf /opt/cmak/conf

RUN chown scala:scala /init.sh /kinit.sh /opt/cmak
ENV KINIT_KEYTAB=/app/keytab 
USER scala
#ENTRYPOINT /bin/bash
CMD /init.sh
