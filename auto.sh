#!/bin/bash

echo -e "\033[33;5mCreating Tables\033[0m"

cat create.sql | mysql --host=db.cs.ship.edu --user=csc371-30 --password=Password30 --database=csc371-30 -vvv > log.txt

clear

echo "Tables Created"
echo -e "\033[33;5mInserting Sample Data\033[0m"

cat seed.sql | mysql --host=db.cs.ship.edu --user=csc371-30 --password=Password30 --database=csc371-30 -vvv >> log.txt

clear

echo "Tables Created"
echo "Seed Data Inserted"