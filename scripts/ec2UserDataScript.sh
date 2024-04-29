#AMAZON LINUX 2023
#!/bin/bash
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade
dnf install java-17-amazon-corretto -y
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
mount -o remount,size=10G /tmp/
yum install docker -y
systemctl start docker
chmod 666 /var/run/docker.sock
systemctl enable docker
yum install -y git
yum install npm -y
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl.sha256
sha256sum -c kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
git clone https://github.com/rutwikdeshmukh/netflix-clone.git
cd netflix-clone
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Ubuntu User Data Script
#!/bin/bash
sudo su
git clone https://github.com/rutwikdeshmukh/netflix-clone.git
cd netflix-clone
apt-get install dkpg
bash scripts/InstallAWSCLI.sh
bash scripts/InstallKUBECTL.sh
bash scripts/InstallDocker.sh
bash scripts/InstallJenkins.sh
bash scripts/InstallTrivy.sh
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community