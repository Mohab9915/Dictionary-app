pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('Setup Dependencies') {
            steps {
                sh '''
                    if command -v docker-compose >/dev/null 2>&1; then
                        echo "Checking docker-compose version..."
                        if docker-compose --version; then
                            echo "docker-compose is working properly"
                        else
                            echo "docker-compose exists but may be broken, reinstalling..."
                            echo "Installing docker-compose..."
                            apt-get update
                            apt-get install -y docker.io curl git
                            curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                            chmod +x /usr/local/bin/docker-compose
                        fi
                    else
                        echo "docker-compose not found"
                        install_docker_compose
                    fi
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "Cleaning up old containers and images..."
                    docker-compose down db web
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    try {
                        sh '''
                            
                            rm -r /var/jenkins_home/workspace/Dictionary-app
                            
                            cd /var/jenkins_home/workspace
                            
                            git clone https://github.com/Mohab9915/Dictionary-app.git
                        '''
                    } catch (Exception e) {
                        error "Failed to clone repository: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('Build and Deploy') {
            steps {
                script {
                    try {
                        sh '''
                            cd /var/jenkins_home/workspace/Dictionary-app
                            docker-compose build web db
                            docker-compose up -d web db
                            
                            echo "Waiting for containers to start..."
                            sleep 15
                            
                            echo "Container status:"
                            docker-compose ps
                        '''
                    } catch (Exception e) {
                        error "Deployment failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }

    post {
        failure {
            sh '''
                echo 'Pipeline failed! Cleaning up...'
                cd /var/jenkins_home/workspace/Dictionary-app
                docker-compose down || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
