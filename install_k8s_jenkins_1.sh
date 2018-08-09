#!/bin/sh
# This is a comment!
# Day la file de build moi truong de chay he thong CI/CD:
# 1. Setup K8S tren GCP
# 2. Setup jenskin. authencication
# 3. 

#----------------Setup moi truong K8S--------------------#
#Cau hinh zone mac dinh tren GCP
gcloud config set compute/zone asia-east1-a

#Tao he thong K8S
echo "#-------------------------------------------------------------------#"
echo "#                 Dang tao cluster kubernetes                       #"
echo "#-------------------------------------------------------------------#"
gcloud beta container clusters create demo-jenskin \
--num-nodes 3 \
--machine-type n1-standard-2 \
--disk-type pd-ssd \
--disk-size 20

#Chung thuc cum cluster vua moi tao
gcloud container clusters get-credentials demo-jenskin

#-----------------Setup Helm------------------------#
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh
helm init
echo "\n\n"

#-----------------Setup Permissions in the cluster for Helm (install packet in helm)-------#
echo "------------Setup Permissions tren K8S de cai packet tren Helm------------------------"
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'


echo "#-------------------------------------------------------------------#"
echo "#         Chuan bi setup jenkins, se bat dau trong 1 phut...        #"
echo "#-------------------------------------------------------------------#"
sleep 1m
echo "#-----------------Setup Jenkins----------------------#"
helm install --name my-jenkins stable/jenkins --set NetworkPolicy.Enabled=true
echo "\n\n"
#get pod

echo "#----------------Thong tin ve pods------------------#"
kubectl get pods
echo "\n\n"

echo "#----------------Thong tin ve services------------------#"
kubectl get svc
echo "\n\n"

#---------------Trien khai source mau de chay pipeline---------------#
echo "#-------------------------------------------------------------------#"
echo "#                   Chuyen den thu muc source code                  #"
echo "#-------------------------------------------------------------------#"
cd demo-app/
echo "------------------------------------"
pwd
echo "------------------------------------"
echo "\n\n"

echo "#-------------------------------------------------------------------#"
echo "#           Tao namespace va deploy dich vu lan dau tien            #"
echo "#-------------------------------------------------------------------#"
kubectl create ns production
kubectl --namespace=production apply -f k8s/production
kubectl --namespace=production apply -f k8s/canary
kubectl --namespace=production apply -f k8s/services

#Scale he thong frontend tu 1 len 4 ban (replicas=4)
kubectl --namespace=production scale deployment gceme-frontend-production --replicas=4
echo "\n\n"

#---------Tao repository Registry tren GCP va authencication--------------
echo "#-------------------------------------------------------------------#"
echo "#        Push source code len repository registry Google Cloud      #"
echo "#-------------------------------------------------------------------#"
git init
git config credential.helper gcloud.sh
gcloud source repos create demo-jenkins
git remote add origin https://source.developers.google.com/p/vn-cloudace-dataengine-2018/r/demo-jenkins
git config --global user.email "dinh@cloud-ace.com"
git config --global user.name "dinh@cloud-ace.com"
git add .
git commit -m "Initial commit"
git push origin master
echo "\n"
sleep 1m

echo "#----------------Thong tin truy cap Jenkins UI------------------#"
kubectl get svc
echo "\n"

echo "#------------------Mat khau dang nhap Jenkins-----------------------#"
printf $(kubectl get secret --namespace default my-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
echo "#-------------------------------------------------------------------#"
echo "\n"

echo "#----------------Thong tin front-end web UI------------------#"
kubectl --namespace=production get service gceme-frontend
echo "\n"

echo "#-------------------------------------------------------------------#"
echo "#            HE THONG DA HOAN THANH XAY DUNG MOI TRUONG!            #"
echo "#                      --------Thanks-------                        #"
echo "#-------------------------------------------------------------------#"
















































































