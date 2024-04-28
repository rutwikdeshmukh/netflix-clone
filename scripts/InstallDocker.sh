sudo apt-get update
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
chmod 666 /var/run/docker.sock
sudo usermod -a -G docker $(whoami)
docker --version
