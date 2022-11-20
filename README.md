## Simple Web Server with Flask by Docker Container & Kubernetes (K8s) ##

### Requirements & Installations ###
<b>Linux:</b>

If you want to run k8s over a linux distribution you need to install a virtual machine environment such as VirtualBox:<br>
https://www.virtualbox.org/<br> 

Then you need to downlad a linux distribution and install it to your VirtualBox.<br> 
https://www.debian.org/download <br> 

<b>Docker: </b> <br> 
https://www.docker.com/products/docker-desktop/<br>

<b>Minikube: </b> <br>
https://minikube.sigs.k8s.io/docs/start/ <br>

### Building Docker Image ###
Once you cloned the project to your local computer, you can run this command below to build the docker image, but be sure that docker is running
and you are working in the main project folder!<br>

docker image build -t flask_docker .

### Running Docker Image ###
docker run -p 5000:5000 -d flask_docker

### Endpoints ###
To check if it's running on your browser: 

http://localhost:5000/ <br>

or in terminal:<br>
curl http://localhost:5000/ <br>


### Deploying our Flask app to Docker Hub ###
docker login <br>
docker tag flask_docker {your-docker-hub-username}/flask-docker <br>
docker push {your-docker-hub-username}/flask-docker <br>

## Start Minikube activate Required addons ##

Once you installed the linux on virtualbox you need to setup docker in linux distribution and then you can setup minikube there and start minikube by running: <br>
minikube start<br>
minikube addons enable ingress<br>



## Configure kubernetes.yaml ##
You must firstly add a new namespace rather than working in default. To do that:<br>
kubectl create namespace {your_namespace}<br>

To see if it is created: <br>
kubectl get namespaces<br>

Then you must exchange your namespace in Deployment, Service and ingress components by {your_namespace}
You must also need to change the image name in kubernetes.yaml by {your-docker-hub-username}/flask-docker. <br>
You must also need to change ingress rule host by your given path for example:{your-app-name.com} <br>

It may seem like that:
---
``` YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
  namespace: {your_namespace}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: {your-docker-hub-username}/flask-docker:latest
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
  namespace: {your_namespace}
spec:
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: {your_namespace}
spec:
  rules:
    - host: {your-app-name.com}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: flask-app-service
                port:
                  number: 80
``` 
---

### Apply Deployment & Services & Ingress ###
kubectl apply -f kubernetes.yaml

### Configure /etc/hosts ###
To get docker container ip of minikube to update /etc/hosts:  <br>
minikube ip

Once you get the ip of minikube you can update now by adding this lines to your hosts file /etc/hosts by: <br>
firstly open hosts file by running: <br>
sudo vim /etc/hosts

Then add map this ingress rule with your ip by adding that line:<br>
ip_of_minikube    {your-app-name.com}

### Endpoint in Kubernetes ###
Once you save and exit you must reach your app by {your-app-name.com}<br>
curl {your-app-name.com}





