
cd demo-app/
kubectl create ns production
kubectl --namespace=production apply -f k8s/production
kubectl --namespace=production apply -f k8s/canary
kubectl --namespace=production apply -f k8s/services

kubectl --namespace=production scale deployment gceme-frontend-production --replicas=4

