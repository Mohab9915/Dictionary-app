pipeline{
    agent any
    stages {
        stage('Clone Repository'){
            steps {
                sh 'rm -rf *'
                git branch: 'main', url: 'https://github.com/Mohab9915/Dictionary-app.git'
            }
            
        }
        
        stage('Build Docker Containers'){
            steps{
                sh 'docker-compose build'
            }
        }
        
        stage('Deploy Containers'){
            steps{
                sh 'docker-compose up -d'
            }
        }
    }
}