#!/bin/ash
  while [ "$(mariadb --socket=${MARIADB_SOCKET} --execute "SELECT 1 FROM information_schema.ENGINES WHERE engine='innodb' AND support in ('YES', 'DEFAULT', 'ENABLED');" | awk '{print $1}' | head -2  | tail -1)" -le "0" ]; do
    sleep 2
  done

  exit 0