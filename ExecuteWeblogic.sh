
#!/bin/bash

cd /scratch/gsh/OBDX/wls/OBDX201
rm -rf logs/*

cd domain/obdx_domain/servers/AdminServer
rm -rf tmp/* cache/* logs/*

cd ../OBDX_MS11/
rm -rf tmp/* cache/* logs/*

cd /
#su - gsh
cd /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain
sh /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/bin/startWebLogic.sh &

cd /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/bin
sh /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/bin/startNodeManager.sh &

