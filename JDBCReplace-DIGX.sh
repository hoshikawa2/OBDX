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
echo 'sed -i "s~<url></url>~<url>'$jdbcstring'</url>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/jdbc/'$line >> execution.sh
echo 'sed -i "s~<password-encrypted></password-encrypted>~<password-encrypted>'$jdbcpassword'</password-encrypted>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/jdbc/'$line >> execution.sh
echo 'sed -i "s~<url>[^{}]*</url>~<url>'$jdbcstring'</url>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/jdbc/'$line >> execution.sh
echo 'sed -i "s~<password-encrypted>{AES256}[^{}]*</password-encrypted>~<password-encrypted>'$jdbcpassword'</password-encrypted>~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/jdbc/'$line >> execution.sh
done < $filename
set +f
sh execution.sh
