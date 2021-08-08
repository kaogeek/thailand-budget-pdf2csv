# CSV-to-DB

This module provide a local database and import script to import data into the database.
It should make querying data easier.

## Prerequisite
- [Docker](https://www.docker.com/)

## Usage
```
# Go into this directory
cd ./csv-to-db

# Start local Postgres with docker-compose, the database will run at localhost:5432
docker compose up -d

# Download full csv, create the table and import it to the local database
./import_data

# Connect to the database from command line
./connect.sh

# Run one off sql command
./run_sql -c "select count(*) from budget limit 5;"

# Or connect with docker
docker exec -it $(docker ps | grep 'kaogeek' | awk -F ' ' '{print $1}') psql -U kaogeek -p 5432 -d thailand_budget_db
```

## Utilities
- `./run_sql` is a script that help you run one of SQL command via SQL string or SQL file

```shell
# Run a sql command from your shell
./run_sql -c "drop table if exists budget;"

# Run a sql file from your shell
./run_sql -f create-report-table.sql
```

- `./connect` is a script that connect you to the local Postgres DB with `psql`

- Both command provide `-h` help flag for more details
