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

# Create the table
./run_sql create-report-table.sql

# Connect to the database from command line
./connect.sh

# Or connect with docker
docker exec -it $(docker ps | grep 'kaogeek' | awk -F ' ' '{print $1}') psql -U kaogeek -p 5432 -d thailand_budget_db
```
