# Base Infrastructure Setup on AWS and Kubernetes Deployment

This guide will help you set up the base infrastructure on AWS using CloudFormation, deploy a Jenkins server, SonarQube, Argo CD, Prometheus, and Grafana. You will also learn how to deploy an application to a Kubernetes cluster.

## Prerequisites

1. AWS Account
2. EC2 KeyPair - Create a new key pair in the EC2 Console and save the `.pem` file securely.
3. API Key from 'themoviedb.org'

## Base Infrastructure Setup

### Step 1: Deploy the CloudFormation template "infra.yml"

### Step 2: Set up Jenkins and SonarQube

1. Connect to the newly created EC2 instance
2. Retrieve the initial admin password for Jenkins
3. Access Jenkins and configure the first admin user
4. Access SonarQube, update the default password, and generate a new token
5. Configure Jenkins to use SonarQube

### Step 3: Prepare the Kubernetes cluster

1. Log into the serial console of the EC2 instance
2. Configure AWS CLI with your AWS access key and secret key
3. Update the Kubernetes configuration for the cluster

### Step 4: Set up Argo CD

1. Install Argo CD using Helm
2. Configure Argo CD to use a LoadBalancer service
3. Create a new application in Argo CD for your Git repository and the desired path

### Step 5: Set up Prometheus

1. Install Prometheus using Helm
2. Configure Prometheus to use a LoadBalancer service

### Step 6: Set up Grafana

1. Install Grafana using Helm
2. Configure Grafana to use a NodePort service
3. Connect Grafana to Prometheus as a data source
4. Import a dashboard from Grafana.com

## Helm and Kubernetes Commands

- `helm repo add <REPO_NAME> <REPO_URL>`
- `helm repo update`
- `helm install <RELEASE_NAME> <CHART_NAME>`
- `kubectl create namespace <NAMESPACE_NAME>`
- `kubectl config set-context --current --namespace=<NAMESPACE_NAME>`
- `kubectl edit svc <SERVICE_NAME>`
- `kubectl get all --all-namespaces | grep LoadBalancer`

## Code Snippets

**Jenkinsfile:**

**infra.yml:**

```yaml
# Your CloudFormation template to set up the base infrastructure including a Kubernetes cluster in the AWS Cloud