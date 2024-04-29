DevOps from scratch: Creating the Base Infrastructure on AWS to Deploying Application to Kubernetes cluster.

========Prerequisites========
    1. AWS Account
    2. EC2 KeyPair - Navigate to "EC2 Console >> Network & Security Security >> Key Pairs" and click on "Create key pair". Provide the name and choose "RSA" as the key pair type and ".pem" as the Private key file format. Click on create and keep the auto-downloaded key pair safe as it would be required to log in to the EC2 Server.
    3. API Key from 'themoviedb.org'

========Setting up the Base Infrastructure in AWS========
    #Step 1:    Deploy the CloudFormation template "infra.yml"
    #Step 2:
                1. Connect to the newly created EC2 instance using "Session Manager" or by running "ssh -i "<KEY_PAIR_NAME.pem>" ec2-user@<EC2_PUBLIC_IP_ADDRESS>" from the command line (Start the command line from the folder which has the key pair or CD into it).
                2. Once logged in to the serial console of the EC2, execute "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" and notedown the CREDENTIALS.
                3. Open a browser and connect to Jenkins with this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:8080". Provide the CREDENTIALS from #STEP 2.2 and configure the first admin user for Jenkins.
                4. Open one more browser window for Sonarqube and visit this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:9000". Provide the CREDENTIALS (USER:'admin' + PASS:'admin') and then update the default password on the next page.
                5. Once Logged in, Navigate to Administration >> Security >> Users >> Tokens >> Update Tokens >> Generate Token and keep it saved somewhere.
                6. Open the Jenkins Server, Navigate to Manage Jenkins >> Plugins >> Install 'SonarQube Scanner for Jenkins'
                7. Navigate to Manage Jenkins >> System >> SonarQube servers >> Name=sonar-server; Server URL=<DEFAULT>; Server authentication token >> Add > Jenkins > Domain=Global credentials >  Kind=Secret text > Secret="TOKEN FROM STEP 2.5" > ID=sonar-token  > Add.
                8. Navigate to Dashboard >> New Item >> Create your first pipeline and name it "CI". Use the "Jenkinsfile" or its contents for Pipeline Script.(Change the variable values accordingly before creating the pipeline) >> Build Now
    #Step 3: 
                1. Log into the serial console of the EC2
                2. execute 'cd ../../'
                3. execute 'sudo bash netflix-clone/scripts/CheckServices.sh' >> See if all the requirements are met or not.
                4. execute 'cd netflix-clone/'
                5. Configure AWS CLI with your AWS access key and secret key
                6. execute 'aws eks update-kubeconfig --region ap-south-1 --name NetflixClone-cluster'

    #Step 4:    ----------ARGO CD----------
                kubectl create namespace argocd
                helm repo add argo https://argoproj.github.io/argo-helm
                helm install argocd -n argocd argo/argo-cd
                kubectl edit svc argocd-server -n argocd                                                                    >>>> Change type to LoadBalancer from ClusterIP
                kubectl get all -n argocd                                                                                   >>>> Access the LoadBalancer URL for ARGO CD Server
                kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d         >>>> Use the decoded password with 'admin' as username to log into the argocd console
                kubectl create -f ArgoNetflixManifest.yaml
                Console >> Settings >> Repositories >> Connect Repo >> Git Repo Details
                Console >> Applications >> New App >> Application Name + Project Name + SYNC POLICY=Automatic + Repository URL + Path(To ManifestFile) + DESTINATION -- Cluster URL=SelectAvailable + Namespace=default
                # TO DO:: #### kubectl patch svc argocd-server -n argocd -p '{"spec": {"ports": [{"port": 443,"targetPort": 443,"name": "https"},{"port": 80,"targetPort": 80,"name": "http"}],"type": "LoadBalancer"}}'
    #Step 5:    ----------PROMETHEUS----------
                kubectl create namespace monitoring
                helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                helm repo update
                helm install prometheus prometheus-community/prometheus
                kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
    #Step 6:    ----------GRAFANA----------
                helm repo add grafana https://grafana.github.io/helm-charts
                helm repo update
                helm install grafana grafana/grafana
                kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
                kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo






========FILES IN THIS GITHUB REPO========
    1. infra.yml: A cloudformation template to set up the base infrastructure including a kubernetes cluster in the AWS Cloud.
        Resources created by the template:
        a. 1 VPC
        b. 6 Subnets
        c. Internet Gateway
        d. NAT Gateway
        e. 1 EC2 Insance
        f. IAM Roles and Instance Profile
        g. Route Tables
        h. Security Group
        i. 1 EKS Cluster >> 1 EKS Node Group >> 2 EKS Worker Nodes
        j. ECR Private Repository
    2. Jenkinsfile: Contains the groovy script to clone the application code from github, BUILD an DOCKER IMAGE from the code and PUSH it to ECR.





========REFERENCES========
https://aquasecurity.github.io/trivy/v0.50/
https://helm.sh/docs









PORT-FORWARDING == kubectl -n <NAMESPACE_NAME> port-forward service/<SERVICE_NAME> 8080:80
CHANGE-CURRENT-NAMESPACE == kubectl config set-context --current --namespace=


 


----------ARGO CD----------
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd -n argocd argo/argo-cd
kubectl edit svc argocd-server -n argocd                                                                    >>>> Change type to LoadBalancer from ClusterIP
kubectl get all -n argocd                                                                                   >>>> Access the LoadBalancer URL for ARGO CD Server
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d         >>>> Use the decoded password with 'admin' as username to log into the argocd console
kubectl create -f ArgoNetflixManifest.yaml
Console >> Settings >> Repositories >> Connect Repo >> Git Repo Details
Console >> Applications >> New App >> Application Name + Project Name + SYNC POLICY=Automatic + Repository URL + Path(To ManifestFile) + DESTINATION -- Cluster URL=SelectAvailable + Namespace=default
# TO DO:: #### kubectl patch svc argocd-server -n argocd -p '{"spec": {"ports": [{"port": 443,"targetPort": 443,"name": "https"},{"port": 80,"targetPort": 80,"name": "http"}],"type": "LoadBalancer"}}'



kubectl edit svc argocd-server -n argocd >>>> Change type to LoadBalancer from ClusterIP





































========EKSCTL commands to create a cluster========
eksctl create cluster --name netflix-clone --version 1.29 --fargate --with-oidc --region ap-south-1 --vpc-private-subnets subnet-09359a650ff978920,subnet-025ccf229bc29a533 --tags ProjectName=NetflixClone --dry-run > EksctlClusterCreate.yml
eksctl create cluster -f EksctlClusterCreate.yml
eksctl delete cluster --region=ap-south-1 --name=netflix-clone