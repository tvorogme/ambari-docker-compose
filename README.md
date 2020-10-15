`docker-compose exec server bash`
`./entrypoint.sh`
`psql --host postgres --user headlabs --password -f /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql`