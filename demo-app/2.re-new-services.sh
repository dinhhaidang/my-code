
cd demo-app/
kubectl delete namespaces production
sleep 15s
kubectl create ns production
kubectl --namespace=production apply -f k8s/production
kubectl --namespace=production apply -f k8s/canary
kubectl --namespace=production apply -f k8s/services

kubectl --namespace=production scale deployment gceme-frontend-production --replicas=4
kubectl --namespace=production get service gceme-frontend


printf "y/n" | gcloud source repos delete demo-jenkins || true

gcloud source repos create demo-jenkins
git init
git config credential.helper gcloud.sh
git remote add origin https://source.developers.google.com/p/vn-cloudace-dataengine-2018/r/demo-jenkins
git config --global user.email "dinh@cloud-ace.com"
git config --global user.name "dinh@cloud-ace.com"
git add .
git commit -m "Initial commit"
git push origin master
