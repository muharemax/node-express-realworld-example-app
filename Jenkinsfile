pipeline {
    agent any
    environment {
        DockerHubRepo = 'chorba/antcolony'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git credentialsId: 'GITHUB_CREDENTIALS', url: 'https://github.com/muharemax/node-express-realworld-example-app.git'
            }
        }
        
        stage('Docker build') {
            steps {
                bat "docker build -t node-express-app ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS', passwordVariable: 'docker_hub_pwd', usernameVariable: 'docker_hub_username')]) {
                    bat "docker login -u ${env.docker_hub_username} -p ${env.docker_hub_pwd}"
                    bat "docker tag node-express-app ${DockerHubRepo}:node-express-app.latest"
                    bat "docker tag node-express-app ${DockerHubRepo}:node-express-app.v${BUILD_NUMBER}"
                    bat "docker push ${DockerHubRepo}:node-express-app.latest"
                    bat "docker push ${DockerHubRepo}:node-express-app.v${BUILD_NUMBER}"
                }
            }
        }
        
        stage('Remove Unused docker image') {
            steps{
                bat "docker rmi ${DockerHubRepo}:node-express-app.latest"
                bat "docker rmi ${DockerHubRepo}:node-express-app.v${BUILD_NUMBER}"
            }
        }
        
        stage('Deploy to k8s cluster') {
            steps{
                bat "kubectl apply -f Kubernetes/db-deployment.yml"
                bat "kubectl apply -f Kubernetes/backend-deployment.yml"
            }
        }
    }
}