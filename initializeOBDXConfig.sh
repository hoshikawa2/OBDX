#!/bin/bash

touch /domainsDetails.properties
echo "ds.jdbc.new.1=$1" > domainsDetails.properties
echo "ds.password.new.1=$2" >> domainsDetails.properties

# download OBDX-Package
cd /
rm -f OBDX-Package.zip
wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/KjgoW8hjc4BQPl3Oc3shiLS1i8udadfTQiYYE7kZHgmXYmbOWkg_CYh_b4ad2Xgr/n/id3kyspkytmr/b/bucket_banco_conceito/o/OBDX-Package.zip
mv OBDX-Package.zip /
unzip -o /OBDX-Package.zip

wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/VHVj0zRH5z_y5D00FP3peV1XSh1-Pau6IAV9TwYu1dN9VicrDUnuWOEFvauX7vYr/n/id3kyspkytmr/b/bucket_banco_conceito/o/tar
chmod 777 tar
chmod +x tar
mv tar /usr/bin

wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/pUNXmM9YPDDqCtLGfBerHZ2OiCp_lKDmQ-FPpEcKDw2T4c-Xup0mXfJLRwg7bxQf/n/id3kyspkytmr/b/bucket_banco_conceito/o/wls.zip
unzip -o wls.zip
rm -f wls.zip

wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/Mrz870cIIEtdwDz2Tf5UPh0anrStn0Q1_y0kfmySP2M3KEnGN0J7xzv5ta046d7f/n/id3kyspkytmr/b/bucket_banco_conceito/o/ohs.zip
unzip -o ohs.zip
rm -f ohs.zip

cd /scratch/gsh/OBDX
wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/WU9VoJnrhR3deFzQBHURwSifRQ2mov-QGD8DnufjMsTkqc3Z2nbOJJmKx5bfbmCq/n/id3kyspkytmr/b/bucket_banco_conceito/o/ohs.tar.gz
tar -xvf ohs.tar.gz
rm -f ohs.tar.gz

wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/qBt0IF_C8xsBQkUHDt84yJYTQtejodxm9VbmIWYtKq2527dkwaDIdZAmf0Uaza1P/n/id3kyspkytmr/b/bucket_banco_conceito/o/OBDX201.tar.gz
tar -xvf OBDX201.tar.gz
rm -f OBDX201.tar.gz
cd /

wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/cCXclv-Ni5KWyRgcGckOgrwkKh_J4o9Q5yXeutg81j5cKJ-_mIZ8cHJg6f38dKPZ/n/id3kyspkytmr/b/bucket_banco_conceito/o/ohssa.tar.gz
tar -xvf ohssa.tar.gz
rm -f ohssa.tar.gz

cd /scratch/gsh/oracle/wlserver/server
wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/n7bWnNDx4335X-xjinor9d6Drgp23burHDQGyGLZBBFFwJpmcLYuwaVqsI8AelH3/n/id3kyspkytmr/b/bucket_banco_conceito/o/lib.tar.gz
mv lib lib_bkp
tar -xvf lib.tar.gz

cd /

mv index.html /scratch/gsh/OBDX/ohs/deploy/index.html
mv config.js /scratch/gsh/OBDX/ohs/deploy/framework/js/configurations/config.js
mv require-config.59c6a4b2a8e15107d995.js /scratch/gsh/OBDX/ohs/deploy/framework/js/configurations/require-config.59c6a4b2a8e15107d995.js
mv security.b715375b6895dba422d4.js /scratch/gsh/OBDX/ohs/deploy/framework/js/configurations/security.b715375b6895dba422d4.js

cd /scratch/gsh/OBDX/wls/OBDX201
rm -rf logs/*

cd domain/obdx_domain/servers/AdminServer
rm -rf tmp/* cache/* logs/*

cd ../OBDX_MS11/
rm -rf tmp/* cache/* logs/*

cd /

export  LD_LIBRARY_PATH=/scratch/gsh/oracle/oracle_common/adr

sh /ohs-config.sh

sh /JDBCReplace-B1A1.sh /JDBCList-B1A1 $1 $2
sh /JDBCReplace-DIGX.sh /JDBCList-DIGX $1 $2
sh /JDBCReplace-jps-config.sh /JDBCList-jps-config $1 $2
sh /weblogic-config.sh
sh /nodemanager-config.sh

sh sendmail_config.sh

sleep 600

sh /ExecuteWeblogic.sh
sleep 180
sh /StartApps.sh
