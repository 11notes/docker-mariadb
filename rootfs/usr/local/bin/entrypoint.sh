#!/bin/ash
  if [ -z "${1}" ]; then
    create-database
    set -- mariadbd --defaults-file=${MARIADB_CONF}     
    eleven log start
  fi

  exec "$@"