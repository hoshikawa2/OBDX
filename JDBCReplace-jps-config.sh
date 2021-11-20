#!/bin/bash
set -f
#su - gsh
echo "" > execution.sh
filename=$1
jdbcstring=$2
jdbcpassword=$3
while read line; do
# reading each line
echo $line
echo 'sed -i "s~<property name=\"jdbc.url\" value=\"[^{}]*\"/>~<property name=\"jdbc.url\" value=\"'$jdbcstring'\"/>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/'$line >> execution.sh
echo 'sed -i "s~<property name=\"audit.loader.jdbc.string\" value=\"[^{}]*\"/>~<property name=\"audit.loader.jdbc.string\" value=\"'$jdbcstring'\"/>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/'$line >> execution.sh
done < $filename
set +f
sh execution.sh
