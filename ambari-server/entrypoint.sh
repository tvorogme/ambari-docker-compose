ambari-server setup -j /usr/jdk64/jdk1.8.0_112 --database=postgres --databasehost=postgres --databaseusername=headlabs --databasepassword=headlabs --databaseport=5432 --databasename=headlabs -s
PGPASSWORD=headlabs psql --host postgres --user headlabs --password -f /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql
ambari-server start
