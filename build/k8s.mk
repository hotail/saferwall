k8s-kubectl-install:	## Install kubectl
	sudo apt-get update && sudo apt-get install -y apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl

k8s-minikube-install:	## Install minikube
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x minikube
	sudo cp minikube /usr/local/bin && rm minikube

k8s-minikube-start:		## Start minikube
	minikube start --cpus 4 --memory 8192

k8s-deploy-cb:	## Deploy couchbase in kubernetes cluster
	cd  $(ROOT_DIR)/build/k8s ; \
	kubectl create -f crd.yaml ; \
	kubectl create -f cluster-role-sa.yaml ; \
	kubectl create -f cluster-role-user.yaml ; \
	kubectl create serviceaccount couchbase-operator --namespace default ; \
	kubectl create clusterrolebinding couchbase-operator --clusterrole couchbase-operator --serviceaccount default:couchbase-operator ; \
	kubectl create -f operator.yaml ; \
	kubectl create -f secret.yaml ; \
	cbopctl create -f couchbase-cluster.yaml 

k8s-deploy-nsq:			## Deploy NSQ in kubernetes cluster
	cd  $(ROOT_DIR)/build/k8s ; \
	kubectl create -f nsqlookupd.yaml ; \
	kubectl create -f nsqd.yaml ; \
	kubectl create -f nsqadmin.yaml
	
k8s-deploy-minio:		## Deploy minio
	cd  $(ROOT_DIR)/build/k8s ; \
	kubectl create -f minio-standalone-pvc.yaml ; \
	kubectl create -f minio-standalone-deployment.yaml ; \
	kubectl create -f minio-standalone-service.yaml

k8s-deploy-backend:		## Deploy backend in kubernetes cluster
	kubectl create -f backend.yaml



	kubectl delete deployment couchbase-operator
	kubectl delete cbc cb-saferwall
	kubectl delete deployments backend

	kubectl delete deployment couchbase-operator
	kubectl delete crd couchbaseclusters.couchbase.com