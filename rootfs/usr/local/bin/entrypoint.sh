#!/bin/ash
  if [ -z "${1}" ]; then
    if [ -z "$(ls -A ${APP_ROOT}/var)" ]; then
      eleven log info "creating new database [mariadb]"
      mariadb-install-db \
        --datadir=/mariadb/var \
        --skip-test-db \
        --auth-root-authentication-method=socket \
        --auth-root-socket-user=docker &> /dev/null

      mariadbd --defaults-file=${MARIADB_CONF} &
      sleep 5
      mariadb --socket=${MARIADB_SOCKET} --execute "CREATE DATABASE IF NOT EXISTS mariadb;" mysql &> /dev/stdout
      mariadb --socket=${MARIADB_SOCKET} --execute "CREATE USER 'mariadb'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIADB_PASSWORD}') OR unix_socket; GRANT ALL PRIVILEGES ON  *.* to 'mariadb'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" mysql  &> /dev/stdout
      mariadb --socket=${MARIADB_SOCKET} --execute "CREATE USER 'mariabackup'@'localhost' IDENTIFIED VIA unix_socket; GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT, BINLOG MONITOR ON *.* TO 'mariabackup'@'localhost'; FLUSH PRIVILEGES;" mysql  &> /dev/stdout
      kill -9 $(pgrep -f 'mariadbd')
    fi

    set -- mariadbd --defaults-file=${MARIADB_CONF}     
    eleven log start
  fi

  exec "$@"