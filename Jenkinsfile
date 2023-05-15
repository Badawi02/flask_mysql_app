pipeline {
    agent any
    environment {
        USER_ID  = credentials('AWS_USER_ID')

    }

    stages {

        stage('login to ECR') {
            
            steps {
                script{
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                        sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY}  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com """
                    }
                }
            }
        }

        stage('build flask image') {
            steps {
                sh """ docker build -t flask_app:${BUILD_NUMBER} Flask_Mysql_app/FlaskApp """
            }
        }

        stage('build mysql image') {
            steps {
                sh """ docker build -t mysql:${BUILD_NUMBER} Flask_Mysql_app/db """
            }
        }

        stage('tag flask image') {
            steps {
                sh """ docker tag flask_app:${BUILD_NUMBER} ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER} """
            }
        }

        stage('tag mysql image') {
            steps {
                sh """ docker tag mysql:${BUILD_NUMBER} ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER} """
            }
        }

        stage('push flask image') {
            steps {
                sh """ docker push ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER} """
            }
        }

        stage('push mysql image') {
            steps {
                sh """ docker push ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER} """
            }
        }

        stage('echo flask build number') {
            steps {
                sh """ echo ${BUILD_NUMBER} > ../flask_app-build-number.txt """
            }
        }

        stage('echo user id') {
            steps {
                sh """ echo ${USER_ID} > ../flask_app-user-id.txt """
            }
        }

        stage('login to cluster') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                            sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} aws eks --region us-east-1 update-kubeconfig --name cluster """
                    }
                }
            }
        }

        stage('export build number for flask app') {
            steps {
                sh """ export BUILD_NUMBER=\$(cat ../flask_app-build-number.txt) """
            }
        }

        stage('export user id ') {
            steps {
                sh """ export USER_ID=\$(cat ../flask_app-user-id.txt) """
            }
        }

        stage('replace build number for flask app') {
            steps {
                sh """ 
                    mv DeploymentFiles_app/deploy_app.yml DeploymentFiles_app/deploy_app.yml.tmp
                    cat DeploymentFiles_app/deploy_app.yml.tmp | envsubst > DeploymentFiles_app/deploy_app.yml
                    rm -f DeploymentFiles_app/deploy_app.yml.tmp
                """
            }
        }

        stage('replace build number for mysql db') {
            steps {
                sh """ 
                    mv DeploymentFiles_app/deploy_db.yml DeploymentFiles_app/deploy_db.yml.tmp
                    cat DeploymentFiles_app/deploy_db.yml.tmp | envsubst > DeploymentFiles_app/deploy_db.yml
                    rm -f DeploymentFiles_app/deploy_db.yml.tmp
                """
            }
        }

        stage('deploy nginx ingress controller') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                            sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f DeploymentFile_nginx_ingress_controller """
                }
            }
        }

        stage('deploy manifists files for app') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                            sh """ AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f DeploymentFiles_app """
                }
            }
        }

        stage('deploy ingress for app') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                            sh """
                                sleep 30
                                AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl apply -f DeploymentFile_ingress
                            """
                }
            }
        }
        
        
        stage('Getting Service Ip') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY')]){
                            sh """
                                
                                AWS_ACCESS_KEY_ID=${ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${SECRET_KEY} kubectl -n ingress-nginx -ojson get service ingress-nginx-controller > sv.json
                                jq '.status.loadBalancer.ingress[0].hostname' sv.json > url.txt
                                sed -i 's/^./http:\\/\\//;s/.\$/:8080/' url.txt
                                cat url.txt
                            """
                }
            }
        }
        
    }
}
