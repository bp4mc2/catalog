
1. Set de juiste tenant en default subscription:

    .. code-block:: console
    
        $ az login --tenant "ordinavisionlab.onmicrosoft.com"
        $ az account set --subscription "Visionworks - LinkedDataLab"
        
2. Create Azure Container Repository:

    De ACR is beperkt tot de 'Basic' SKU die genoeg capaciteit biedt voor ons
    beperkte gebruik. Daarna wordt er ingelogd zodat de ACR gebruikt kan worden
    met lokale Docker en Kubernetes tools. `zorg dat docker desktop actief is
    voordat je inlogt!`

    .. code-block:: console
    
        $ az group create --name LinkedDataDefaultRG --location westeurope
        {
          "id": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG",
          "location": "westeurope",
          "managedBy": null,
          "name": "LinkedDataDefaultRG",
          "properties": {
            "provisioningState": "Succeeded"
          },
          "tags": null,
          "type": null
        }
        $ az acr create --resource-group LinkedDataDefaultRG --name LinkedDataACR --sku Basic
        {
          "adminUserEnabled": false,
          "creationDate": "2019-07-30T12:24:05.079120+00:00",
          "id": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG/providers/Microsoft.ContainerRegistry/registries/LinkedDataACR",
          "location": "westeurope",
          "loginServer": "linkeddataacr.azurecr.io",
          "name": "LinkedDataACR",
          "networkRuleSet": null,
          "provisioningState": "Succeeded",
          "resourceGroup": "LinkedDataDefaultRG",
          "sku": {
            "name": "Basic",
            "tier": "Basic"
          },
          "status": null,
          "storageAccount": null,
          "tags": {},
          "type": "Microsoft.ContainerRegistry/registries"
        }
        $ az acr login --name LinkedDataACR
        Login Succeeded
        
3. Build, tag & push containers

        Vraag de loginserver op, build & tag images in een commando.

    .. code-block:: console
        
        $ az acr list --resource-group LinkedDataDefaultRG --query "[].{acrLoginServer:loginServer}" --output table
        AcrLoginServer
        ------------------------
        linkeddataacr.azurecr.io
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-dws:v20190730.1 docker/dotwebstack/.
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-fuseki:v20190730.1 docker/fuseki/.
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-ldt:v20190730.1 docker/ldt/.
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-ldt-config:v20190730.1 docker/ldt-config/.
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-nginx:v20190730.1 docker/nginx/.
        $ docker build --tag linkeddataacr.azurecr.io/bp4mc2-virtuoso:v20190730.1 docker/virtuoso/.
        $ docker images
        REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
        linkeddataacr.azurecr.io/bp4mc2-virtuoso     v20190730.1         dac2bbcd7760        32 seconds ago      292MB
        linkeddataacr.azurecr.io/bp4mc2-nginx        v20190730.1         2781e7c400ab        8 minutes ago       126MB
        linkeddataacr.azurecr.io/bp4mc2-ldt-config   v20190730.1         849a21f4bd04        8 minutes ago       153MB
        linkeddataacr.azurecr.io/bp4mc2-ldt          v20190730.1         53829686ba56        9 minutes ago       696MB
        linkeddataacr.azurecr.io/bp4mc2-fuseki       v20190730.1         109cfedf3192        10 minutes ago      278MB
        linkeddataacr.azurecr.io/bp4mc2-dws          v20190730.1         fc80d586bd59        20 minutes ago      300MB
        tomcat                                       7-jdk8-openjdk      d3977b9baf7d        13 hours ago        506MB
        nginx                                        latest              e445ab08b2be        6 days ago          126MB
        openjdk                                      8-jre               f44b742ffc37        12 days ago         246MB
        debian                                       jessie              652b7a59e393        2 weeks ago         129MB
        $ docker push linkeddataacr.azurecr.io/bp4mc2-virtuoso:v20190730.1
        $ docker push linkeddataacr.azurecr.io/bp4mc2-nginx:v20190730.1
        $ docker push linkeddataacr.azurecr.io/bp4mc2-ldt-config:v20190730.1
        $ docker push linkeddataacr.azurecr.io/bp4mc2-ldt:v20190730.1
        $ docker push linkeddataacr.azurecr.io/bp4mc2-fuseki:v20190730.1
        $ docker push linkeddataacr.azurecr.io/bp4mc2-dws:v20190730.1
        $ az acr repository list --name linkeddataacr --output table
        Result
        -----------------
        bp4mc2-dws
        bp4mc2-fuseki
        bp4mc2-ldt
        bp4mc2-ldt-config
        bp4mc2-nginx
        bp4mc2-virtuoso

4. Maak een AKS cluster aan
        
    Een cluster met één node, daarvoor is nodig:
        
        - Een AD service principal (één jaar geldig)
        - Koppelling tussen de principal en de ACR zodat deze images op kan halen
        - Maak een AKS cluster aan
        - Haal AKS credentials op
        - Check de verbinding
        
    .. code-block:: console
    
        $ az ad sp create-for-rbac --name ldt-cluster --skip-assignment
        Changing "ldt-cluster" to a valid URI of "http://ldt-cluster", which is the required format used for service principal names
        {
          "appId": "58f2c52e-04d0-428a-93bc-56c0928ca401",
          "displayName": "ldt-cluster",
          "name": "http://ldt-cluster",
          "password": "b592513d-34e3-454d-b7e6-ed00100d9a2f",
          "tenant": "a7491a83-8433-4cfe-860b-d877c8cc8d03"
        }
        $ az acr show --resource-group LinkedDataDefaultRG --name LinkedDataACR --query "id" --output tsv
        /subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG/providers/Microsoft.ContainerRegistry/registries/LinkedDataACR
        $ az role assignment create --assignee 58f2c52e-04d0-428a-93bc-56c0928ca401 --scope /subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG/providers/Microsoft.ContainerRegistry/registries/LinkedDataACR --role acrpull
        {
          "canDelegate": null,
          "id": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG/providers/Microsoft.ContainerRegistry/registries/LinkedDataACR/providers/Microsoft.Authorization/roleAssignments/eaa3b648-2c4e-4fce-8649-7b8c48df0310",
          "name": "eaa3b648-2c4e-4fce-8649-7b8c48df0310",
          "principalId": "dd105f4b-f147-451d-a247-65d2c881ae6e",
          "principalType": "ServicePrincipal",
          "resourceGroup": "LinkedDataDefaultRG",
          "roleDefinitionId": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43fe172d538d",
          "scope": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourceGroups/LinkedDataDefaultRG/providers/Microsoft.ContainerRegistry/registries/LinkedDataACR",
          "type": "Microsoft.Authorization/roleAssignments"
        }
        $ az aks create \
              --resource-group LinkedDataDefaultRG \
              --name ldt-AKSCluster \
              --location westeurope \
              --node-vm-size Standard_D2_v3 \
              --node-count 1 \
              --service-principal 58f2c52e-04d0-428a-93bc-56c0928ca401 \
              --client-secret b592513d-34e3-454d-b7e6-ed00100d9a2f \
              --generate-ssh-keys
        {
          "aadProfile": null,
          "addonProfiles": null,
          "agentPoolProfiles": [
            {
              "availabilityZones": null,
              "count": 1,
              "enableAutoScaling": null,
              "maxCount": null,
              "maxPods": 110,
              "minCount": null,
              "name": "nodepool1",
              "orchestratorVersion": "1.12.8",
              "osDiskSizeGb": 100,
              "osType": "Linux",
              "provisioningState": "Succeeded",
              "type": "AvailabilitySet",
              "vmSize": "Standard_D2_v3",
              "vnetSubnetId": null
            }
          ],
          "apiServerAuthorizedIpRanges": null,
          "dnsPrefix": "ldt-AKSClu-LinkedDataDefaul-5a2a01",
          "enablePodSecurityPolicy": null,
          "enableRbac": true,
          "fqdn": "ldt-aksclu-linkeddatadefaul-5a2a01-7329dc8d.hcp.westeurope.azmk8s.io",
          "id": "/subscriptions/5a2a017e-0e75-43c1-949c-0763293f5bd1/resourcegroups/LinkedDataDefaultRG/providers/Microsoft.ContainerService/managedClusters/ldt-AKSCluster",
          "identity": null,
          "kubernetesVersion": "1.12.8",
          "linuxProfile": {
            "adminUsername": "azureuser",
            "ssh": {
              "publicKeys": [
                {
                  "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtMae0K9DUX1EVLaF0VV162fQc8khZBJ2JL4Wl4LOvT+c6nNRybUJ07LBopma2ouDcORITcDnHj1D0YHcBrgERiSFFmcbuOdvSMjNC9yM3/h/EtM8wuEUAtmYR2/STYLhr/IixOebpQrBpEmY0tO/Hbmqdm80R0xM9UJfbWAlkmeL9EWgUn1stsYH+PSVWpH7HVGIrkU6XY52PmFmJAer0E/h7kTOfrb9RsC+XWg6wDfT0R7y6XZH4FP/RPDYlnkMg5xWW1GHNQOCTFWQbn229N4hofaYh4NGaDdpwSj3oRBIDpf/XbT7B0lH5sYPNGvd6Oj0dFfa8egGLSbSZk6OrQ== oneman@mrwhite.local\n"
                }
              ]
            }
          },
          "location": "westeurope",
          "maxAgentPools": 1,
          "name": "ldt-AKSCluster",
          "networkProfile": {
            "dnsServiceIp": "10.0.0.10",
            "dockerBridgeCidr": "172.17.0.1/16",
            "loadBalancerSku": "basic",
            "networkPlugin": "kubenet",
            "networkPolicy": null,
            "podCidr": "10.244.0.0/16",
            "serviceCidr": "10.0.0.0/16"
          },
          "nodeResourceGroup": "MC_LinkedDataDefaultRG_ldt-AKSCluster_westeurope",
          "provisioningState": "Succeeded",
          "resourceGroup": "LinkedDataDefaultRG",
          "servicePrincipalProfile": {
            "clientId": "58f2c52e-04d0-428a-93bc-56c0928ca401",
            "secret": null
          },
          "tags": null,
          "type": "Microsoft.ContainerService/ManagedClusters",
          "windowsProfile": null
        }
        $ az aks get-credentials --resource-group LinkedDataDefaultRG --name ldt-AKSCluster
        Merged "ldt-AKSCluster" as current context in /Users/oneman/.kube/config
        $ kubectl get nodes
        NAME                       STATUS    ROLES     AGE       VERSION
        aks-nodepool1-20998271-0   Ready     agent     15m       v1.12.8
        
5. Deploy containers
        
    Bestaande docker setup omzettten naar kubernetes en deploy-en:
    
        - installeer kompose
        - converteer de bestaand docker componse file
        - pas de compose file aan naar de Azure container registry
        - deploy pod
        
    .. code-block:: console
    
        $ brew install kompose
        $ mkdir kompose && cd kompose
        $ kompose convert ../docker-compose.yml
        INFO Kubernetes file "dotwebstack-service.yaml" created 
        INFO Kubernetes file "fuseki-service.yaml" created 
        INFO Kubernetes file "ldt-service.yaml" created   
        INFO Kubernetes file "virtuoso-service.yaml" created 
        INFO Kubernetes file "webserver-service.yaml" created 
        INFO Kubernetes file "dotwebstack-deployment.yaml" created 
        INFO Kubernetes file "fuseki-deployment.yaml" created 
        INFO Kubernetes file "ldt-deployment.yaml" created 
        INFO Kubernetes file "ldt-config-deployment.yaml" created 
        INFO Kubernetes file "virtuoso-deployment.yaml" created 
        INFO Kubernetes file "webserver-deployment.yaml" created
        
    Vervang in elke manifest deployment file de container image door de complete
    ACR locatie, bijvoorbeeld:
    
        image: bp4mc2-nginx
        name: webserver
        
    wordt
        
        image: linkeddataacr.azurecr.io/bp4mc2-nginx:v20190730.1
        name: webserver

    .. code-block:: console
        
        $ cd ./kompose
        $ kubectl apply -f .
        deployment.extensions "dotwebstack" created
        service "dotwebstack" created
        deployment.extensions "fuseki" created
        service "fuseki" created
        deployment.extensions "ldt-config" created
        deployment.extensions "ldt" created
        service "ldt" created
        deployment.extensions "virtuoso" created
        service "virtuoso" created
        deployment.extensions "webserver" created
        service "webserver" created
        $ kubectl get service webserver
        NAME        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
        webserver   ClusterIP   10.0.55.179   <none>        80/TCP    9m
        $ kubectl get service ldt
        NAME      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
        ldt       ClusterIP   10.0.52.229   <none>        8080/TCP   9m
        $ kubectl get service virtuoso
        NAME       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
        virtuoso   ClusterIP   10.0.231.109   <none>        8890/TCP   9m
        $ kubectl get service fuseki
        NAME      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
        fuseki    ClusterIP   10.0.21.189   <none>        3030/TCP   9m
        $ kubectl get service dotwebstack
        NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
        dotwebstack   ClusterIP   10.0.244.251   <none>        8081/TCP   10m
        $ kubectl get pods
        NAME                           READY     STATUS    RESTARTS   AGE
        dotwebstack-785757c5b5-rcqzw   1/1       Running   0          17m
        fuseki-7df899fcf8-gptz9        1/1       Running   0          17m
        ldt-776bc9b466-r2nfg           1/1       Running   0          17m
        ldt-config-ff8f47986-v2ds7     1/1       Running   0          17m
        virtuoso-5dc6dc5959-hmzmd      1/1       Running   0          17m
        webserver-66fbd6c5f5-7stwq     1/1       Running   0          17m
        
6 Delete cluster

    Je kunt een bestaand AKS cluster niet pauzerenm alleen verwijderen.
    
    .. code-block:: console
    
        $ az aks delete --resource-group LinkedDataDefaultRG --name ldt-AKSCluster --subscription "Visionworks - LinkedDataLab" --no-wait