#!/bin/ash
  if [ "$(query "SELECT 1 FROM information_schema.ENGINES WHERE engine='innodb' AND support in ('YES', 'DEFAULT', 'ENABLED');" 1)" -le "0" ]; then
    exit 1; 
  fi

  exit 0