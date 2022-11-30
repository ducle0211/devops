#!/bin/bash
day=$(date +%Y_%m_%d)
branch="backend"
folder="$branch-$day"

host="<IP>"
port="<PORT>"
user="<USER>"
pass="<Pass>"

#Full
# tiup dumpling -h $host -P $port -u $user -p $pass  -F 100MiB -t 16 -o ./$folder

#No table
# tiup dumpling -h $host -P $port -u $user -p $pass  -F 100MiB -t 16 -o ./$folder -f '<database>.*' -f '!*.<table>'

# Export table
# tiup dumpling -h $host -P $port -u $user -p $pass  -F 100MiB -t 16 --filetype sql -o ./table-$folder --filter "*.table" --where 'created BETWEEN "2022-09-09T00:00:00.000Z" AND "2022-09-09T23:59:59.999Z"'