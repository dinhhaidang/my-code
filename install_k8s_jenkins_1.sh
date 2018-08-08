#!/bin/sh
# This is a comment!
# Day la file de build moi truong de chay he thong CI/CD:
# 1. Setup K8S tren GCP
# 2. Setup jenskin. authencication
# 3. 

#----------------Setup moi truong K8S--------------------#
#Cau hinh zone mac dinh tren GCP
gcloud config set compute/zone asia-east1-a

#Clone bo source code sample ve
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

#Tao he thong K8S
gcloud container clusters create demo-jenskin \
--num-nodes 3 \
--machine-type n1-standard-2 \
--disk-type pd-ssd \
--disk-size 20 \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

#Chung thuc cum cluster vua moi tao
gcloud container clusters get-credentials demo-jenskin

#-----------------Setup Helm------------------------#
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh
helm init

#-----------------Setup Permissions in the cluster for Helm (install packet in helm)-------#
echo "---------------------Setup Permissions in the cluster for Helm----------------------------"
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

#-----------------Setup Jenkins----------------------#
helm install --name my-jenkins stable/jenkins --set NetworkPolicy.Enabled=true

#get pod
kubectl get pods

#get service (LoadBalancer) de thay IP external cua jenkins UI
kubectl get svc

#get password dang nhap Jenkins web UI
printf $(kubectl get secret my-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

#---------------Trien khai source mau de chay pipeline---------------#
echo "#------------------Chuyen den thu muc source code-------------------------#"
cd continuous-deployment-on-kubernetes/sample-app/
echo "------------------------------------"
pwd
echo "------------------------------------"

#tao namespace cho viec trien khai bo source
kubectl create ns production

#--------------Deploy lan dau tien de chay dich vu-----------------#
kubectl --namespace=production apply -f k8s/production
kubectl --namespace=production apply -f k8s/canary
kubectl --namespace=production apply -f k8s/services

#Scale he thong frontend tu 1 len 4 ban (replicas=4)
kubectl --namespace=production scale deployment gceme-frontend-production --replicas=4

#get IP external front-end system sau khi deployment
kubectl --namespace=production get service gceme-frontend

#---------Tao repository Registry tren GCP va authencication--------------
git init
git config credential.helper gcloud.sh
gcloud source repos create demo-jenkins
git remote add origin https://source.developers.google.com/p/vn-cloudace-dataengine-2018/r/demo-jenkins

#dinh danh chinh minh
git config --global user.email "dinh@cloud-ace.com"
git config --global user.name "dinh@cloud-ace.com"

#Add, commit, va push source len repositories cua google
git add .
git commit -m "Initial commit"
git push origin master

















































































