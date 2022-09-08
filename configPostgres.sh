#! /bin/sh
# Configure database inside docker 

#!/bin/bash

set -e
service postgresql start

DB_NAME=${1:-cmsdb}
DB_USER=${2:-cmsuser}
DB_USER_PASS=${3:-SciTULP64}

su postgres <<EOF
createdb  $DB_NAME;
psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_USER_PASS';"
psql -c "grant all privileges on database $DB_NAME to $DB_USER;"
echo "Postgres User '$DB_USER' and database '$DB_NAME' created."
psql --username=postgres --dbname=cmsdb --command='ALTER SCHEMA public OWNER TO cmsuser'
psql --username=postgres --dbname=cmsdb --command='GRANT SELECT ON pg_largeobject TO cmsuser'
EOF

cmsInitDB
