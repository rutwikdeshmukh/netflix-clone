# DevOps from scratch: Creating the Base Infrastructure on AWS to Deploying Application to Kubernetes cluster.

This guide will help you set up the base infrastructure on AWS using CloudFormation, deploy a Jenkins server, SonarQube, Argo CD, Prometheus, and Grafana. You will also learn how to deploy an application to a Kubernetes cluster.

## Prerequisites

1. AWS Account
2. EC2 KeyPair - Create a new key pair in the EC2 Console and save the `.pem` file securely.
3. API Key from 'themoviedb.org'

## Base Infrastructure Setup

### Step 1: Deploy the CloudFormation template "infra.yml"

### Step 2: Set up Jenkins and SonarQube

1. Connect to the newly created EC2 instance using "Session Manager" or by running "ssh -i "<KEY_PAIR_NAME.pem>" ec2-user@<EC2_PUBLIC_IP_ADDRESS>" from the command line (Start the command line from the folder which has the key pair or CD into it).
2. Once logged in to the serial console of the EC2, execute "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" and notedown the CREDENTIALS.
3. Open a browser and connect to Jenkins with this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:8080". Provide the CREDENTIALS from #STEP 2.2 and configure the first admin user for Jenkins.
4. Open one more browser window for Sonarqube and visit this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:9000". Provide the CREDENTIALS (USER:'admin' + PASS:'admin') and then update the default password on the next page.
5. Once Logged in, Navigate to Administration >> Security >> Users >> Tokens >> Update Tokens >> Generate Token and keep it saved somewhere.
6. Open the Jenkins Server, Navigate to Manage Jenkins >> Plugins >> Install 'SonarQube Scanner for Jenkins'
7. Navigate to Manage Jenkins >> System >> SonarQube servers >> Name=sonar-server; Server URL=<DEFAULT>; Server authentication token >> Add > Jenkins > Domain=Global credentials >  Kind=Secret text > Secret="TOKEN FROM STEP 2.5" > ID=sonar-token  > Add.
8. Navigate to Dashboard >> New Item >> Create your first pipeline and name it "CI". Use the "Jenkinsfile" or its contents for Pipeline Script.(Change the variable values accordingly before creating the pipeline) >> Build Now

### Step 3: Connecting to the EKS Cluster

1. Log into the serial console of the EC2
2. execute 'cd ../../'
3. execute 'sudo bash netflix-clone/scripts/CheckServices.sh' >> See if all the requirements are met or not.
4. execute 'cd netflix-clone/'
5. Configure AWS CLI with your AWS access key and secret key
6. execute 'aws eks update-kubeconfig --region ap-south-1 --name NetflixClone-cluster'

### Step 4: Set up Argo CD

1. kubectl create namespace argocd
2. kubectl config set-context --current --namespace=argocd
3. helm repo add argo https://argoproj.github.io/argo-helm
4. helm install argocd argo/argo-cd
5. kubectl edit svc argocd-server >>>>> Change type to LoadBalancer from ClusterIP
6. kubectl get all >>>>> Access the LoadBalancer URL for ARGO CD Server
7. kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d >>>> Use the decoded password with 'admin' as username to log into the argocd console
9. kubectl create -f ArgoNetflixManifest.yaml
- `Console >> Settings >> Repositories >> Connect Repo >> Git Repo Details`
- `Console >> Applications >> New App >> Application Name + Project Name + SYNC POLICY=Automatic + Repository URL + Path(To ManifestFile) + DESTINATION -- Cluster URL=SelectAvailable + Namespace=default`

### Step 5: Set up Prometheus

1. kubectl create namespace monitoring
2. kubectl config set-context --current --namespace=monitoring
3. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
4. helm repo update 
5. helm install stable prometheus-community/kube-prometheus-stack
6. kubectl get pods -l "release=stable"
7. kubectl edit svc stable-kube-prometheus-sta-prometheus >>>> Change type to LoadBalancer from ClusterIP
8. kubectl get svc    

### Step 6: Set up Grafana

1. helm repo add grafana https://grafana.github.io/helm-charts
2. helm repo update
3. helm install grafana grafana/grafana
4. kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
5. kubectl edit svc stable-grafana
6. kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
7. If grafana is not accepting the password in the console, do this:
- `kubectl exec --stdin --tty <stable-grafana-POD-NAME> -- /bin/bash`
- `grafana-cli admin reset-admin-password <NEW-PASSWORD>`

### Step 7 (Optional)
1. Login to your grafana console
2. Navigate to Connections >> Add connections >> Search for 'Prometheus' >> Add New Data Sources
3. Provide Name, Server URL(LoadBalancer of Prometheus Server URL) and Click on 'save & test'
4. Navigate to Home >> Dashboards >> New Dashboard >> Import Dashboard and provide the ID of the the desired dashboard from https://grafana.com/grafana/dashboards/

## Kubernetes Commands

1. PORT-FORWARDING:
- `kubectl -n <NAMESPACE_NAME> port-forward service/<SERVICE_NAME> 8080:80`
2. CHANGE-CURRENT-NAMESPACE:
- `kubectl config set-context --current --namespace=`
3. GET-ALL-LBs:
- `kubectl get all --all-namespaces | grep LoadBalancer`
4. EKSCTL-TO-CREATE-CLUSTER:
- `eksctl create cluster --name netflix-clone --version 1.29 --fargate --with-oidc --region ap-south-1 --vpc-private-subnets subnet-09359a650ff978920,subnet-025ccf229bc29a533 --tags ProjectName=NetflixClone --dry-run > EksctlClusterCreate.yml`
- `eksctl create cluster -f EksctlClusterCreate.yml`
- `eksctl delete cluster --region=ap-south-1 --name=netflix-clone`
