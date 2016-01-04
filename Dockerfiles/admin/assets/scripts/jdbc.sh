#!/bin/bash
set -e

Opencast::JDBC::Check() {
  ORG_OPENCASTPROJECT_DB_DDL_GENERATION="${ORG_OPENCASTPROJECT_DB_DDL_GENERATION:-false}"

  Opencast::Helper::CheckForVariables \
    "ORG_OPENCASTPROJECT_DB_DDL_GENERATION" \
    "ORG_OPENCASTPROJECT_DB_JDBC_DRIVER" \
    "ORG_OPENCASTPROJECT_DB_JDBC_URL" \
    "ORG_OPENCASTPROJECT_DB_JDBC_USER" \
    "ORG_OPENCASTPROJECT_DB_JDBC_PASS"
}

Opencast::JDBC::Configure() {
  Opencast::Helper::ReplaceInfile "etc/custom.properties" \
    "ORG_OPENCASTPROJECT_DB_VENDOR" \
    "ORG_OPENCASTPROJECT_DB_DDL_GENERATION" \
    "ORG_OPENCASTPROJECT_DB_JDBC_DRIVER" \
    "ORG_OPENCASTPROJECT_DB_JDBC_URL" \
    "ORG_OPENCASTPROJECT_DB_JDBC_USER" \
    "ORG_OPENCASTPROJECT_DB_JDBC_PASS"
}
