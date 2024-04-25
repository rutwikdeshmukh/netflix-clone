DevOps from scratch: Creating the Base Infrastructure on AWS to Deploying Application to Kubernetes cluster.

====Prerequisites====
    1. AWS Account
    2. EC2 KeyPair - Navigate to "EC2 Console >> Network & Security Security >> Key Pairs" and click on "Create key pair". Provide the name and choose "RSA" as the key pair type and ".pem" as the Private key file format. Click on create and keep the auto-downloaded key pair safe as it would be required to log in to the EC2 Server.

====Setting up the Base Infrastructure in AWS====
    #Step 1:
    1.  Deploy the CloudFormation template "infra.yml"
        Following resources will be created after you deploy the template:
        a. VPC
        b. Subnets
        c. Internet Gateway
        d. NAT Gateway
        e. EC2 Insance
        f. IAM Instance Profile
        g. Route Tables
        h. Security Group
    2. Connect to the newly created EC2 instance using "Session Manager" or by running "ssh -i "<KEY_PAIR_NAME.pem>" ec2-user@<EC2_PUBLIC_IP_ADDRESS>" from the command line (Start the command line from the folder which has the key pair or CD into it).
    3. Once logged in to the serial console of the EC2, execute "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" and notedown the CREDENTIALS.
    4. Open a browser and visit this URL: "http://<EC2_PUBLIC_IP_ADDRESS>:8080". Provide the CREDENTIALS from #STEP 1.3 and configure the first admin user for Jenkins.
    5. Create your first pipeline and name it "CI". Use the "Jenkinsfile" or its contents for Pipeline Script.(Change the variable values accordingly before creating the pipeline)
    6.
    7.
    
aws eks update-kubeconfig --region ap-south-1 --name NetflixClone-cluster 
kubectl -n <NAMESPACE_NAME> port-forward service/<SERVICE_NAME> 8080:80

eksctl commands to create a cluster::
eksctl create cluster --name netflix-clone --version 1.29 --fargate --with-oidc --region ap-south-1 --vpc-private-subnets subnet-09359a650ff978920,subnet-025ccf229bc29a533 --tags ProjectName=NetflixClone --dry-run > EksctlClusterCreate.yml
eksctl create cluster -f EksctlClusterCreate.yml
eksctl delete cluster --region=ap-south-1 --name=netflix-clone