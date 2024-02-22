FROM golang:latest as build-stage

RUN git clone https://github.com/microsoft/go-sqlcmd /sqlcmd

WORKDIR /sqlcmd

RUN cd build && sed -i '4s/.*/CGO_ENABLED=0 go build -o $scriptdir\/..\/sqlcmd  -ldflags="-extldflags=-static -X main.version=$versionTag" $scriptdir\/..\/cmd\/modern/' build.sh && bash build.sh

# FROM mcr.microsoft.com/mssql/server:2022-CU11-ubuntu-22.04
FROM mcr.microsoft.com/azure-sql-edge:latest AS release

LABEL com.bitwarden.product="bitwarden"

ENV MSSQL_TELEMETRY_ENABLED = FALSE

USER root:root

COPY --from=build-stage /sqlcmd/sqlcmd /opt/mssql-tools/bin/sqlcmd

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    gosu \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY backup-db.sql /
COPY backup-db.sh /
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh \
    && chmod +x /backup-db.sh

HEALTHCHECK --start-period=120s --timeout=3s CMD /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U sa -P ${MSSQL_SA_PASSWORD} -Q "SELECT 1" || exit 1

ENTRYPOINT ["/entrypoint.sh"]
