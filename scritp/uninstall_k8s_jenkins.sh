
echo "#-------------------------------------------------------------------#"
echo "#                 Dang xoa cluster kubernetes.....                  #"
echo "#-------------------------------------------------------------------#"
gcloud container clusters delete demo-jenskin


echo "#-------------------------------------------------------------------#"
echo "#                   Xoa source repositories                         #"
echo "#-------------------------------------------------------------------#"
gcloud source repos delete demo-jenkins


echo "#-------------------------------------------------------------------#"
echo "#                   Xoa source repositories                         #"
echo "#-------------------------------------------------------------------#"
gcloud compute networks delete jenkins-demo