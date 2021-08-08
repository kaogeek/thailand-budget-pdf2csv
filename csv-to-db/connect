#! /bin/bash

set -e
docker exec -it $(docker ps | grep 'kaogeek' | awk -F ' ' '{print $1}') psql -U kaogeek -p 5432 -d thailand_budget_db
