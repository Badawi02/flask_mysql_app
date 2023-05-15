# _VOIS-Task
## Tools Used
 - AWS
 - Terraform
 - Docker
 - Kubernates
 - ansible
 - Jenkins
 - Bash script

### Project Details:

 - Infrastructure as code using Terraform that build an environment on AWS content ( An EKS cluster with worker nodes in different availability zones and EC2 to install jenkins in it ) :
     - 1 VPC
     - 2 subnets
     - 1 IGW
     - 1 route table
     - 1 security group
     - 1 EC2
     - 1 cluster
     - 2 worker nodes
     - 2 ECR
 - install jenkins on EC2 using ansible
 - Create A deployment and service definition for a containerized web application running on eks
 - access jenkins from > http://<public_ip for ec2>:8080
 - make ci/cd with jenkins :
     - Containerize a flask app with mysql database and push it to ECR
     - deploy an ingress controller in the EKS cluster , using Nginx.
     - Deploy the app with Kubernetes 
     - access the application through the deployed ingress on port 8080.

### Getting Started

- Download The Code

```bash
  git clone https://github.com/Badawi02/_VOIS-TASK
```
- Setup your AWS account credentials
```bash
  aws configure
```
- Change the path and point it to AWS credentials files like this :
![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/0.png)
-----------------------------------------------------------------------------------------
### Build the Infrastructure
```bash
  cd terraform
```
```bash
  terraform init
```
```bash
  terraform plan
```
```bash
  terraform apply
```
- Output:
![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/1.png)
- Copy the public IP from terrafom 

Now you can check your AWS account, you can see this resources has been created:
- 1 VPC named "vpc-main"
- 2 Subnets
- 1 Internet gateway
- 1 security group 
- 1 routing table
- 1 EC2
- Private Kubernetes cluster (EKS) with 2 worker nodes
- 2 ECR "flask_app" "mysql_db"


## Install Jenkins on EC2 with ansible :
- Run 
```bash
    cd ansible
```
- Put the public ip of EC2 in inventory file
- RUN
```bash
    ansible-playbook -i inventory install_jenkins.yml
```
- Output:
![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/2.png)
- Copy the output from ansible

## Make pipleline :

- You can access jenkins from browser >  http://<public_ip for ec2>:8080
- put the output from ansible in init password like this :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/3.png)
- install suggested plugins :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/4.png)
- create account in Jenkins :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/5.png)
- Now you can enter to jenkins :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/7.png)
- put your credentials ( you must use the same ID ) like this :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/8.png)
- create your pipleline :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/9.png)
- configure your pipleline, put your url of repo and choose your github credentials :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/10.png)
- build your pipleline :
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/11.png)
 ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/12.png)
- From output of jenkins (url) , You can You can access your application :
  ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/13.png)
  ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/14.png)

## You can find all images you build it in ECR :
  ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/15.png)
  ![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/16.png)


## That will deploy on EKS:
- first, SSH to EC2
- Enter your AWS credentials
```bash
    aws configure
```
- connect the ec2 with cluster
```bash
    aws eks --region us-east-1 update-kubeconfig --name cluster
```
- Run 
```bash
    kubectl get all -n ingress-nginx
```
## Now you can show all resources of cluster
- Config Map for environment variables
- Mysql statefulset and Exopse it with ClusterIP service
- PV and PVC as storge for database
- Flask App Deployment and Exopse it with NodePort service
- ingress nginx controller
- ingress for routing the app
- Output:
![agent](https://github.com/Badawi02/_VOIS-TASK/blob/main/SreenShots/17.png)

## Contributors:
- [Ahmed Badawi](https://github.com/Badawi02)
