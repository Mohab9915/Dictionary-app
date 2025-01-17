pipeline {
    agent any
    
    environment {
        REPO_URL = 'https://github.com/Mohab9915/Dictionary-app'
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo 'Cloning repository...'
                    git branch: 'main', url: "${REPO_URL}"
                }
            }
        }
        
        stage('Stop Containers') {
            steps {
                script {
                    echo 'Stopping any running containers...'
                    sh '''
                    docker compose down || true
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo 'Building Docker images...'
                    sh '''
                    docker compose -f ${DOCKER_COMPOSE_FILE} build
                    '''
                }
            }
        }
        
        stage('Deploy Containers') {
            steps {
                script {
                    echo 'Deploying containers...'
                    sh '''
                    docker compose up -d
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
