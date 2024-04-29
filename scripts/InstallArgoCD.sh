sudo su
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd -n argocd argo/argo-cd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"ports": [{"port": 443,"targetPort": 443,"name": "https"},{"port": 80,"targetPort": 80,"name": "http"}],"type": "LoadBalancer"}}'
