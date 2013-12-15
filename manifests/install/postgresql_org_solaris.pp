# = Class: postgresql::install::postgresql_org_solaris
#
# This class installs postgres on Solaris from the postgresql.org binaries
# Installation procedure based on http://wiki.pbnet.dk/doku.php?id=solaris11:postgresql:install
#
class postgresql::install::postgresql_org_solaris {

  # Packages from http://www.postgresql.org/ftp/binary/

  # mkdir -p /var/svc/manifest/application/database
  # chmod 555 /var/svc/manifest/application/database
  # chmod 555 /lib/svc/method
  # mkdir /opt/pgsql
  # mkdir -p /var/lib/pgsql/data

  # chown -R postgres:postgres /var/lib/pgsql/data
  # bunzip2 < postgresql-9.1.3-S11.i386-64.tar.bz2 | tar xpf -
  # cd postgres/9.1-pgdg
  # sudo mv * /opt/pgsql

  # ln -s /opt/pgsql/bin/64/createdb /usr/bin/createdb
  # ln -s /opt/pgsql/bin/64/createlang /usr/bin/createlang
  # ln -s /opt/pgsql/bin/64/createuser /usr/bin/createuser
  # ln -s /opt/pgsql/bin/64/dropdb /usr/bin/dropdb
  # ln -s /opt/pgsql/bin/64/droplang /usr/bin/droplang
  # ln -s /opt/pgsql/bin/64/dropuser /usr/bin/dropuser
  # ln -s /opt/pgsql/bin/64/initdb /usr/bin/initdb
  # ln -s /opt/pgsql/bin/64/pg_ctl /usr/bin/pg_ctl
  # ln -s /opt/pgsql/bin/64/pg_dump /usr/bin/pg_dump
  # ln -s /opt/pgsql/bin/64/pg_dumpall /usr/bin/pg_dumpall
  # ln -s /opt/pgsql/bin/64/pg_restore /usr/bin/pg_restore
  # ln -s /opt/pgsql/bin/64/postgres /usr/bin/postgres
  # ln -s /opt/pgsql/bin/64/postmaster /usr/bin/postmaster
  # ln -s /opt/pgsql/bin/64/psql /usr/bin/psql
  # ln -s /opt/pgsql/bin/64/vacuumdb /usr/bin/vacuumdb

  # su - postgres
  # postgres@solaris:~$ initdb -E UTF-8 -X /pgdata1/wal /var/lib/pgsql/data
  # postgres@solaris:~$ exit

  # /var/lib/pgsql/data/pg_hba.conf
  # /var/lib/pgsql/data/postgresql.conf

  # cd ~
  # mv postgresql.xml /var/svc/manifest/application/database
  # mv postgresql /lib/svc/method
  # chmod 555 /lib/svc/method/postgresql
  # chown root:bin /lib/svc/method/postgresql
  # cd /var/svc/manifest/application/database
  # svccfg validate postgresql.xml
  # svccfg import postgresql.xml
  # svcs postgresql
  # svcadm enable postgresql:default

  # # svcs postgresql

  # /var/svc/log/application-database-postgresql:default.log

}
