
echo "#-------------------------------------------------------------------#"
echo "#                 Dang xoa cluster kubernetes.....                  #"
echo "#-------------------------------------------------------------------#"
gcloud container clusters delete demo-jenskin


echo "#-------------------------------------------------------------------#"
echo "#                   Xoa source repositories                         #"
echo "#-------------------------------------------------------------------#"
gcloud init
gcloud source repos delete demo-jenkins