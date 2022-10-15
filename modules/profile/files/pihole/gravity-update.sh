#!/bin/bash
DATE=$(date '+%Y-%m-%d')
DIR="/etc/pihole"
TEXTFILE="adlists.list"
#prepare SQL FILEs
cat <<EOF > ${DIR}/flushdb.sql
DELETE FROM adlist;
EOF
cat <<EOF > ${DIR}/tmpdb.sql
CREATE TEMP TABLE i(txt);
.separator ~
.import ${DIR}/${TEXTFILE} i
INSERT OR IGNORE INTO adlist (address) SELECT txt FROM i;
DROP TABLE i;
EOF
#TRUNCATE DB
sqlite3 /etc/pihole/gravity.db < ${DIR}/flushdb.sql
#IMPORT FILE to DB
sqlite3 /etc/pihole/gravity.db < ${DIR}/tmpdb.sql
pihole -g
