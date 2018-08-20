gcloud config set compute/zone asia-east1-a

gcloud beta container clusters create k8s-istio \
--num-nodes 3 \
--network jenkins-demo \
--machine-type n1-standard-2 \
--disk-type pd-ssd \
--disk-size 20 \
--scopes "https://www.googleapis.com/auth/projecthosting,storage-rw,cloud-platform"