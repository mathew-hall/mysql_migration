FROM mysql
MAINTAINER Mathew Hall <mathew.james.hall+gh@gmail.com>

ADD migrate.sh /migrate.sh
RUN mkdir /docker-entrypoint-migrations.d
VOLUME /docker-entrypoint-migrations.d

CMD /migrate.sh