echo "Docker Version:"
docker --version
echo "AWSCLI Version:"
aws --version
echo "Node Version:"
node -v
echo "NPM Version:"
npm -v
echo "Jenkins Status Version:"
systemctl status jenkins | grep Active
echo "Trivy Version:"
trivy -v
echo "KUBECTL Version:"
kubectl version --client