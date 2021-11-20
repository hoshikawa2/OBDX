#!/bin/bash
set -f
#su - gsh
echo "" > execution.sh
echo 'sed -i "s~172.17.0.2~localhost~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/config.xml' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/config.xml' >> execution.sh
echo 'sed -i "s~172.17.0.2~localhost~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/servers/AdminServer/applications/em/META-INF/emoms.properties.jmxori' >> execution.sh

echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/init-info/tokenValue.properties' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/servers/OBDX_MS11/data/nodemanager/startup.properties' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/servers/OBDX_MS11/data/nodemanager/boot.properties' >> execution.sh
echo 'sed -i "s~5556~5557~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/servers/AdminServer/applications/em/META-INF/emoms.properties' >> execution.sh
echo 'sed -i "s~172.17.0.2~localhost~g" /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/servers/AdminServer/applications/em/META-INF/emoms.properties' >> execution.sh

set +f
sh execution.sh
