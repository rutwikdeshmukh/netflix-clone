DevOps from scratch: Creating the Base Infrastructure on AWS to Deploying Application to Kubernetes cluster.

========Prerequisites========
    1. AWS Account
    2. EC2 KeyPair - Navigate to "EC2 Console >> Network & Security Security >> Key Pairs" and click on "Create key pair". Provide the name and choose "RSA" as the key pair type and ".pem" as the Private key file format. Click on create and keep the auto-downloaded key pair safe as it would be required to log in to the EC2 Server.
    3. API Key from 'themoviedb.org'

========Setting up the Base Infrastructure in AWS========
    #Step 1:
    1.  Deploy the CloudFormation template "infra.yml"
    2. Connect to the newly created EC2 instance using "Session Manager" or by running "ssh -i "<KEY_PAIR_NAME.pem>" ec2-user@<EC2_PUBLIC_IP_ADDRESS>" from the command line (Start the command line from the folder which has the key pair or CD into it).
    3. Once logged in to the serial console of the EC2, execute "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" and notedown the CREDENTIALS.
    4. Open a browser and visit this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:8080". Provide the CREDENTIALS from #STEP 1.3 and configure the first admin user for Jenkins.
    5. Create your first pipeline and name it "CI". Use the "Jenkinsfile" or its contents for Pipeline Script.(Change the variable values accordingly before creating the pipeline)
    6.
    7.




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

















========CONNECTING TO THE CLUSTER=======
aws eks update-kubeconfig --region ap-south-1 --name NetflixClone-cluster 
kubectl -n <NAMESPACE_NAME> port-forward service/<SERVICE_NAME> 8080:80
kubectl -n netflix-clone-ns port-forward service/netflix-clone-755d5cc96-pgbkj 8080:80
kubectl -n netflix-clone-ns port-forward service/netflix-clone-cluster-ip 8080:80

========EKSCTL commands to create a cluster========
eksctl create cluster --name netflix-clone --version 1.29 --fargate --with-oidc --region ap-south-1 --vpc-private-subnets subnet-09359a650ff978920,subnet-025ccf229bc29a533 --tags ProjectName=NetflixClone --dry-run > EksctlClusterCreate.yml
eksctl create cluster -f EksctlClusterCreate.yml
eksctl delete cluster --region=ap-south-1 --name=netflix-clone
