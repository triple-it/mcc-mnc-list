#!/usr/bin/env bash
mysql -u root  -e 'SET GLOBAL local_infile = true;'
mysql -u radius radius < ./mcc-mnc-list.sql
cat mcc-mnc-list.json | jq -r '.[] | [.type, .countryName, .countryCode, .mcc, .mnc, .brand, .status, .bands, .notes] | @csv' > mcc-mnc-list.csv

mysql --local-infile=1 -u radius radius -e "LOAD DATA LOCAL INFILE 'mcc-mnc-list.csv' INTO TABLE mccmnclist FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
mysql -u radius radius  -e 'ALTER TABLE `mccmnclist` ADD `id` INT NOT NULL AUTO_INCREMENT primary key;'
mysql -u radius radius -e 'create view v_mccmnclist  as select *,concat(mcc,mnc) as mccmnc from mccmnclist;'
mysql -u radius radius -e 'create view v_radpostauth as select radpostauth.*,v_mccmnclist.countryCode,v_mccmnclist.brand from radpostauth inner join v_mccmnclist on v_mccmnclist.mccmnc = radpostauth.mccmnc;'
