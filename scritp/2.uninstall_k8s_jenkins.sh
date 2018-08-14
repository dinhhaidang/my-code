
echo "#-------------------------------------------------------------------#"
echo "#                 Dang xoa cluster kubernetes.....                  #"
echo "#-------------------------------------------------------------------#"
printf "y\n" | gcloud container clusters delete demo-jenskin || true


echo "#-------------------------------------------------------------------#"
echo "#                   Xoa source repositories                         #"
echo "#-------------------------------------------------------------------#"
printf "y/n" | gcloud source repos delete demo-jenkins || true


echo "#-------------------------------------------------------------------#"
echo "#                   Xoa source repositories                         #"
echo "#-------------------------------------------------------------------#"
printf "y/n" | gcloud compute networks delete jenkins-demo || true
