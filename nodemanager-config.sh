#!/bin/bash
set -f
#su - gsh
echo "" > execution.sh
echo 'sed -i "s~172.17.0.2~localhost~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/nodemanager/nodemanager.properties' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/nodemanager/nodemanager.properties' >> execution.sh
#echo 'sed -i "s~5556~5557~g" /scratch/gsh/oracle/ohssa/user_projects/domains/ohsDomain/init-info/startscript.xml' >> execution.sh
#echo 'sed -i "s~5556~5557~g" /scratch/gsh/oracle/ohssa/user_projects/domains/ohsDomain/init-info/tokenValue.properties' >> execution.sh
#echo 'sed -i "s~5556~5557~g" /scratch/gsh/oracle/ohssa/user_projects/domains/ohsDomain/init-info/nodemanager-properties.xml' >> execution.sh


echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/init-info/nodemanager-properties.xml' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/init-info/startscript.xml' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/config.xml' >> execution.sh

set +f
sh execution.sh
