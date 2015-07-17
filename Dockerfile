FROM ubuntu:14.04

# install PostgreSQL
RUN apt-get -y update \
  && apt-get install -y locales \
  && apt-get -y install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# cofigure db to use our data directory
RUN sed -i -e"s/data_directory =.*$/data_directory = '\/data'/" /etc/postgresql/9.3/main/postgresql.conf

# allow connections from all ip addresses 
RUN sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/9.3/main/pg_hba.conf

EXPOSE 5432

WORKDIR /etc/
RUN mkdir service \
  && cd service \
  && mkdir postgresql \

VOLUME ["/data", "/var/log/postgresql", "/etc/postgresql"]
