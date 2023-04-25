#!/usr/bin/env bash
mysql -u radius radius < ./mcc-mnc-list.sql
cat mcc-mnc-list.json | jq -r '.[] | [.type, .countryName, .countryCode, .mcc, .mnc, .brand, .status, .bands, .notes] | @csv' > mcc-mnc-list.csv

mysql --local-infile=1 -u radius radius -e "LOAD DATA LOCAL INFILE 'mcc-mnc-list.csv' INTO TABLE mccmnclist FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
mysql -u radius -p -e 'ALTER TABLE `mccmnclist` ADD `id` INT NOT NULL AUTO_INCREMENT primary key;'
