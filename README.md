# Deploying OBDX in OCI OKE with ORACLE VISUAL BUILDER STUDIO

This document will show how to:

* Deploy quickly an OBDX Image
* Create a Container OBDX Image
* Create a DevOps build and deploy OBDX inside a Kubernetes Cluster

Layers for Containerization:
* OBDX
* WebLogic Configuration
* Database Configuration
* OBDX Servers

## For manual deployment (Simple way)

This is the rapid way to deploy the OBDX in your cluster.
Attention for the CPU and Memory pre-requisites:

    5CPUs
    40Gb RAM
#
Execute the YAML obdx-test.yaml to start a OBDX Weblogic instance on the cluster.
If you want to clusterize your instances, you have to do it manually.
#
    If you already have a Pod/Deployment, and do not want to clear your Load-Balancers IPs:

    kubectl delete deployment obdx-deployment.yaml
   
    ------
  
    Or if you want to create a new Deployment with Services:
 
    kubectl apply -f obdx-test.yaml
    
    Remember: Change the JDBC parameters inside obdx-test.yaml

## Building OBDX Docker Image

    You can build a customized image of OBDX, but you can use this images on my repository:
        
    iad.ocir.io/id3kyspkytmr/flexcube/ohsgsh:latest
    iad.ocir.io/id3kyspkytmr/flexcube/weblogicgsh:latest

    There are 2 containers inside the obdx pod:

    ohsgsh
    weblogicgsh

Here I explain how to make your OBDX base images in docker, but YOU DO NOT NEED TO CREATE THESE OBDX DOCKER IMAGES.
YOU CAN SIMPLY USE THE IMAGES SAVED ON THE REPOSITORY.

    iad.ocir.io/id3kyspkytmr/flexcube/ohsgsh:latest
    iad.ocir.io/id3kyspkytmr/flexcube/weblogicgsh:latest

Move domain folder wls.zip, ohs.zip and ohs.tar.gz from this object storage images:

    ohs.zip
    https://objectstorage.us-ashburn-1.oraclecloud.com/p/Mrz870cIIEtdwDz2Tf5UPh0anrStn0Q1_y0kfmySP2M3KEnGN0J7xzv5ta046d7f/n/id3kyspkytmr/b/bucket_banco_conceito/o/ohs.zip

    wls.zip
    https://objectstorage.us-ashburn-1.oraclecloud.com/p/pUNXmM9YPDDqCtLGfBerHZ2OiCp_lKDmQ-FPpEcKDw2T4c-Xup0mXfJLRwg7bxQf/n/id3kyspkytmr/b/bucket_banco_conceito/o/wls.zip

    ohs.tar.gz
    https://objectstorage.us-ashburn-1.oraclecloud.com/p/WU9VoJnrhR3deFzQBHURwSifRQ2mov-QGD8DnufjMsTkqc3Z2nbOJJmKx5bfbmCq/n/id3kyspkytmr/b/bucket_banco_conceito/o/ohs.tar.gz


After uncompress the files on the root, create your docker images like:

    docker run --name weblogicgsh -h "gsh" -v <External Volume Mount>:/scratch/gsh/OBDX/wls -p 7001-7010:7001-7010 -it < docker FMW infra Image> /bin/bash

    where <External Volume Mount> represents your uncompressed structure in last step.
    If you uncompressed the files in the root, you can get 
    <External Volume Mount> : /scratch/gsh/OBDX/wls

weblogicgsh is one from 2 images you need. Another is ohsgsh. You can create your docker image with:

    sudo docker run --name ohsgsh -h "gsh" -v /scratch/gsh/OBDX/ohs:/scratch/gsh/oracle/bootdir -p 7777:7777 -it ohsgsh:12.2.1.3.0 /bin/bash


### Prepare the weblogicgsh docker image
Now, we need to start the image to configure the weblogicgsh image:

    sudo docker start weblogicgsh

Then execute:

    docker exec -it weblogicgsh /bin/bash

Move wls, ohs inside docker and make folder structure exactly like onprem : /scratch/gsh/OBDX/wls/OBDX201 and  /scratch/gsh/OBDX/ohs

    ohs and wls in the same folder (OBDX)

ohs contains ui folder (deploy)
make sure the folder OBDX201 is present inside wls
MOVE lib.tar.gz (present inside wls ) to “/scratch/gsh/oracle/wlserver/server” (inside docker)

lib present in “scratch/gsh/oracle/wlserver/server” (inside docker) should be replaced with the above downloaded lib.tar.gz. Please make sure you take a backup of existing lib folder

lets refer this lib as new-lib

lib.tar.gz is need to be uncompressed. So replace original folder in ../oracle as mentioned above

Replace lib (present in docker path) : “/scratch/gsh/oracle/wlserver/server”  with new-lib

Change the DB ip and port and service name if it has been changed to all the xml files(ALL the files B1A1,DIGIX etc) present in jdbc folder path : /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/jdbc

Change the DB ip and port and service name if it has been changed to all the xml files(ALL the files B1A1,DIGIX etc) present in path : /scratch/gsh/ OBDX/wls/OBDX201/domain/obdx_domain/config/jms

Update Db ip and port path in below 2 files :-

    1. /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/jps-config.xml
    2. /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/config/fmwconfig/jps-config-jse.xml

Now start WebLogic (startWebLogic.sh) and Node Manager (startNodeManager.sh) from putty by going inside docker container weblogicgsh

    Path for startWebLogic.sh : /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain
    Path for startNodeManager.sh : /scratch/gsh/OBDX/wls/OBDX201/domain/obdx_domain/bin

Hit WebLogic console URL and login with with weblogic/welcome1

Update services(UBS, ELCM,OBTF,OBCL,OBDX web host etc) ip/port in obdx database DIGX (username/password : OBDX_GSH/welcome1)  table name : digx_fw_config_Var_B

Restart Managed server from WebLogic console

Hit OBDX APP URL and login with user credential

And for push the docker image to OCIR:


weblogicgsh

    sudo docker stop weblogicgsh

    sudo docker commit weblogicgsh flexcube/weblogicgsh:v1
    sudo docker tag flexcube/weblogicgsh:v1 iad.ocir.io/id3kyspkytmr/flexcube/weblogicgsh:v1
    sudo docker push iad.ocir.io/id3kyspkytmr/flexcube/weblogicgsh:v1
 
ohsgsh

    sudo docker stop ohsgsh

    sudo docker commit ohsgsh flexcube/ohsgsh:v1
    sudo docker tag flexcube/ohsgsh:v1 iad.ocir.io/id3kyspkytmr/flexcube/ohsgsh:v1
    sudo docker push iad.ocir.io/id3kyspkytmr/flexcube/ohsgsh:v1


## Automating the deployment for OKE (DevOps)

#### Change Database Password to AES format with weblogic.security.Encrypt

First we need to get the database (a template backup of an Oracle Database for the OBDX) password. The password original will not work inside the scripts for this automation. The password needs to be converted in AES format, so you need to use the **setWLSEnv.sh** script to get your passsword into this format:

    cd /scratch/gsh/oracle/wlserver/server/bin
    .  ./setWLSEnv.sh
    java -Dweblogic.RootDirectory=/scratch/gsh/OBDX144/user_projects/domains/OBDX  weblogic.security.Encrypt <Database Password>

#### Environment Variables

The DevOps process needs only these 2 parameters to run OBDX inside a Kubernetes Cluster:

    $JDBCPassword: {AES256}7kfaltdnEBjKNq.......RIU0IcLOynq1ee8Ib8=     (In AES format*)
    $JDBCString: <JDBC Connection String>

#### DevOps Configuration

This is the DevOps shell script to prepare a OBDX Image and make it work for use. This can be used in Jenkins or **Oracle Visual Builder Studio**

#
    OCI CLI Install
    Unix Shell

    #  Prepare for kubectl from OCI CLI
    mkdir -p $HOME/.kube
    oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.iad.aaaaaaaaae3tmyldgbtgmyjrmyzdeytbhazdmmbrgfstmntdgc2wmzrxgbrt --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0
    export KUBECONFIG=$HOME/.kube/config
    # Set Variables
    export JDBCString=$JDBCString
    export JDBCPassword=$JDBCPassword
    # setup the JDBC variables in OBDX144-devops.yaml
    sed -i "s~--JDBCString--~$JDBCString~g" OBDX144-devops.yaml
    sed -i "s~--JDBCPassword--~$JDBCPassword~g" OBDX144-devops.yaml
    # Deploy OBDX144
    kubectl config view
    kubectl replace -f OBDX144-devops.yaml --force

# 

You can configure your Build Pipeline in **Oracle Visual Builder Studio** like this:

**Git Configuration:**
![vbst-git-config.png](https://github.com/hoshikawa2/repo-image/blob/master/vbst-git-config.png?raw=true)

**Parameters Configuration:**
![vbst-config-parameters.png](https://github.com/hoshikawa2/repo-image/blob/master/vbst-config-parameters.png?raw=true)

**Steps Configuration**
![vbst-config-steps2.png](https://github.com/hoshikawa2/repo-image/blob/master/vbst-config-steps2.png?raw=true)

#### YAML file for deploy the OBDX Image into the Kubernetes Cluster


This is the file responsible for deploy your OBDX image into Kubernetes Cluster.
The configuration file replaces the $JDBCString and $JDBCPassword environment variables before execution. The scripts inside this projects will configure your Weblogic instance with all parameters.

    Deployment YAML (obdx-test.yaml)

    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: obdx-deployment
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: obdx
      template:
        metadata:
          labels:
            app: obdx
        spec:
          hostname: gsh
          hostAliases:
          - ip: "127.0.0.1"
            hostnames:
            - "gsh.oracle.com"
          containers:
          - name: ohsgsh
            image: iad.ocir.io/id3kyspkytmr/flexcube/ohsgsh:latest
            #image: iad.ocir.io/id3kyspkytmr/oraclefmw-infra_with_patch:12.2.1.4.0
            command: [ "/bin/sh", "-c"]
            args: [ "sleep 180; cd /; yum install tar -y; wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/GEofC4bpkPdb3qkApDYYG2LKHDfgXz3q_6rzgEKDDcBcIcLGr6xK9dK9ecN7pNSB/n/id3kyspkytmr/b/bucket_banco_conceito/o/initializeOHSConfig.sh; sh initializeOHSConfig.sh; while true; do sleep 30; done;" ]
            ports:
            - name: port7777
              containerPort: 7777
            - name: port5557
              containerPort: 5557
            - name: port4443
              containerPort: 4443
          - name: weblogicgsh
            image: iad.ocir.io/id3kyspkytmr/flexcube/weblogicgsh:latest
            #image: iad.ocir.io/id3kyspkytmr/oraclefmw-infra_with_patch:12.2.1.4.0
            command: [ "/bin/sh", "-c"]
            args: [ "sleep 180; cd /; yum install tar -y; wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/oCZ4K4pdurtR4adOwhxJn6GF8VZQ4AhDikLksnnz3T1yEEUAa5p3MNukRUPV8pSw/n/id3kyspkytmr/b/bucket_banco_conceito/o/initializeOBDXConfig.sh; sh initializeOBDXConfig.sh <OBDX Oracle Database URL> {AES256}<password>; while true; do sleep 30; done;" ]
            ports:
            - name: port7001
              containerPort: 7001
            - name: port7002
              containerPort: 7002
            - name: port7003
              containerPort: 7003
            - name: port7004
              containerPort: 7004
            - name: port7005
              containerPort: 7005
            - name: port7006
              containerPort: 7006
            - name: port7007
              containerPort: 7007
            - name: port7008
              containerPort: 7008
            - name: port7009
              containerPort: 7009
            - name: port7010
              containerPort: 7010
            - name: port5557
              containerPort: 5557
            - name: port7777
              containerPort: 7777
            livenessProbe:
              httpGet:
                path: /console
                port: 7001
              initialDelaySeconds: 4800
              timeoutSeconds: 30
              periodSeconds: 300
              failureThreshold: 3
    #        resources:
    #          requests:
    #            cpu: "1"
    #            memory: "10Gi"
    #          limits:
    #            cpu: "1"
    #            memory: "10Gi"

          restartPolicy: Always
          imagePullSecrets:
          # enter the name of the secret you created
          - name: ocirsecret
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: weblogicgsh-service
      labels:
        app: obdx
    spec:
      selector:
        app: obdx
      ports:
        - port: 7001
          targetPort: 7001
      type: LoadBalancer
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: ohsgsh-service
      labels:
        app: obdx
    spec:
      selector:
        app: obdx
      ports:
        - name: http
          protocol: TCP
          port: 7777
          targetPort: 7777
      type: LoadBalancer
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: mainpage-service
      labels:
        app: obdx
    spec:
      selector:
        app: obdx
      ports:
        - port: 7003
          targetPort: 7003
      type: LoadBalancer


#### Resilience

The OBDX deployment is resilient, so if the Weblogic or OBDX falls down, the Kubernetes Cluster will load and execute again. The responsible for this is the **livenessprobe** inside the **obdx-test.yaml** file.

### Manage the Weblogic manually
If you want to start or stop WebLogic, you can execute these commands.

#### Execute WebLogic

    kubectl exec $(kubectl get pod -l app=weblogicgsh -o jsonpath="{.items[0].metadata.name}") --container weblogicgsh -- /bin/bash -c "sh /ExecuteWeblogic.sh &"

    kubectl exec $(kubectl get pod -l app=weblogicgsh -o jsonpath="{.items[0].metadata.name}") --container weblogicgsh -- /bin/bash -c "sh /StartApps.sh &"

#### Execute commands inside the container

    kubectl exec -it $(kubectl get pod -l app=obdx -o jsonpath="{.items[0].metadata.name}") --container weblogicgsh -- /bin/bash
    kubectl exec -it $(kubectl get pod -l app=obdx -o jsonpath="{.items[0].metadata.name}") --container ohsgsh -- /bin/bash

### The scripts inside this project
These are the scripts responsible for automate the deployment, configuration and execution of the OBDX instance
#### Changing Database Passwords in JDBC Configuration

These scripts change the configuration of all JDBC XML files inside the Weblogic. The environmental variables $JDBCString and $JDBCPassword will be used here

    domainsDetails.properties

    ds.jdbc.new.1=jdbc:oracle:thin:@xxx.xxx.xxx.xxx:1521/DBSTRING.subnet04...815.vcn04...815.oraclevcn.com
    ds.password.new.1={AES256}7kfaltdnEBjKNqdH..............ynq1ee8Ib8=

#

    ChangeJDBC.py

    from java.io import FileInputStream

    propInputStream = FileInputStream("/domainsDetails.properties")
    configProps = Properties()
    configProps.load(propInputStream)
    
    for i in 1,1:
        newJDBCString = configProps.get("ds.jdbc.new."+ str(i))
        newDSPassword = configProps.get("ds.password.new."+ str(i))
        i = i + 1
    
        print("*** Trying to Connect.... *****")
        connect('weblogic','weblogic123','t3://localhost:8001')
        print("*** Connected *****")
        cd('/Servers/AdminServer')
        edit()
        startEdit()
        cd('JDBCSystemResources')
        pwd()
        ls()
        allDS=cmo.getJDBCSystemResources()
        for tmpDS in allDS:
                   dsName=tmpDS.getName();
                   print 'DataSource Name: ', dsName
                   print ' '
                   print ' '
                   print 'Changing Password & URL for DataSource ', dsName
                   cd('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCDriverParams/'+dsName)
                   print('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCDriverParams/'+dsName)
                   set('PasswordEncrypted', newDSPassword)
                   cd('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCDriverParams/'+dsName)
                   set('Url',newJDBCString)
                   print("*** CONGRATES !!! Username & Password has been Changed for DataSource: ", dsName)
                   print ('')
                   print ('')

    save()
    activate()
#
    Important: The JDBC configuration files for the OBDX is on /scratch/gsh/OBDX144/user_projects/domains/OBDX/config/jdbc

#

    ChangeJDBC.sh

    cd /scratch/gsh/oracle/wlserver/server/bin
    .  ./setWLSEnv.sh
    java weblogic.WLST /ChangeJDBC.py

#
#

    JDBCReplace.sh

    #!/bin/bash
    su - gsh
    filename=$1
    while read line; do
    # reading each line
    echo $line
    sed -i 's/<url>jdbc:oracle:thin:@whf00fxh.in.oracle.com:1521\/prodpdb<\/url>/<url>$JDBCString<\/url>/' /scratch/gsh/OBDX144/user_projects/domains/OBDX/config/jdbc/$line
    sed -i 's/<password-encrypted><\/password-encrypted>/<password-encrypted>$JDBCPassword<\/password-encrypted>/' /scratch/gsh/OBDX144/user_projects/domains/OBDX/config/jdbc/$line
    done < $filename

#

    JDBCList

    jdbc2fOBAC-2439-jdbc.xml
    jdbc2fOBIC-2191-jdbc.xml
    jdbc2fPLATO-1684-jdbc.xml
    jdbc2fPLATOBATCH-4386-jdbc.xml
    jdbc2fUBSCUSTOMER-3856-jdbc.xml

#### Starting NodeManager and WebLogic

These scripts start the Weblogic Admin, Node Manager and the application (OBDX) and are used in the automation in the deployment YAML file

    ExecuteWebLogic.sh

    cd /
    su - gsh
    cd /scratch/gsh/OBDX144/user_projects/domains/OBDX/bin
    sh /scratch/gsh/OBDX144/user_projects/domains/OBDX/bin/startNodeManager.sh &
    sh /scratch/gsh/OBDX144/user_projects/domains/OBDX/bin/startWebLogic.sh &

#

    StartApps.py

    from java.io import FileInputStream
    
    print("*** Trying to Connect.... *****")
    connect('weblogic','weblogic123','t3://localhost:8001')
    print("*** Connected *****")
    
    start('config_server')
    
    stopApplication('plato-discovery-service-5.3.0')
    startApplication('plato-discovery-service-5.3.0')
    
    start('ac_server')
    start('cs_server')
    start('ic_server')
    
    disconnect()
    exit()

#

    StartApps.sh

    cd /scratch/gsh/oracle/wlserver/server/bin
    .  ./setWLSEnv.sh
    java weblogic.WLST /StartApps.py

#

    RestartFlexcube.sh

    cd /
    sh ExecuteWebLogic.sh
    sleep 180
    cd /
    sh StartApps.sh




