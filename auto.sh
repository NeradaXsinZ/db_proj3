#!/bin/bash

cat create.sql | mysql --host=db.cs.ship.edu --user=csc371-30 --password=Password30 --database=csc371-30 -vvv 

echo "Done"