#!/bin/bash

# Read the SA_PASSWORD value from a file for swarm environments.
# See https://github.com/Microsoft/mssql-docker/issues/326
if [ ! -z "$MSSQL_SA_PASSWORD" ] && [ ! -z "$MSSQL_SA_PASSWORD_FILE" ]
then
    echo "Provided both MSSQL_SA_PASSWORD and MSSQL_SA_PASSWORD_FILE environment variables. Please only use one."
    exit 1
fi
if [ ! -z "$MSSQL_SA_PASSWORD_FILE" ]
then
    # It should be exported, so it is available to the env command below.
    export MSSQL_SA_PASSWORD=$(cat $MSSQL_SA_PASSWORD_FILE)
fi

# Replace database name in backup-db.sql
if [ ! -z "$DATABASE" ]
then
  sed -i "/^SET @DatabaseName =/s/'[^']*'/'$DATABASE'/" backup-db.sql
  sed -i "/^SET @DatabaseNameSafe =/s/'[^']*'/'${DATABASE// /-}'/" backup-db.sql
fi

# The rest...

mkdir -p /etc/bitwarden/mssql/backups
mkdir -p /var/opt/mssql/data

# Launch a loop to backup database on a daily basis
if [ "$BACKUP_DB" != "0" ]
then
    /bin/sh -c "/backup-db.sh loop >/dev/null 2>&1 &"
fi

exec /bin/sh -c /opt/mssql/bin/launchpadd -usens=false -enableOutboundAccess=true -usesameuser=true -sqlGroup root -- -reparentOrphanedDescendants=true -useDefaultLaunchers=false & /app/asdepackage/AsdePackage & /opt/mssql/bin/sqlservr
