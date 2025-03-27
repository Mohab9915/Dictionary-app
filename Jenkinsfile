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
                        echo "Installing docker-compose..."
                        apt-get update
                        apt-get install -y docker.io curl git
                        curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                        chmod +x /usr/local/bin/docker-compose
                    fi
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    echo "Cleaning up old containers and images..."
                    docker-compose down || true
                    docker volume rm dictionary-app_web_data || true
                    docker system prune -f || true
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    try {
                        sh '''
                            mkdir -p /var/jenkins_home/workspace/Dictionary-app
                            cd /var/jenkins_home/workspace/Dictionary-app
                            
                            # Force clean clone
                            rm -rf ./* ./.* 2>/dev/null || true
                            git clone -b main https://github.com/Mohab9915/Dictionary-app.git .
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
                            
                            echo "Copying files to web container..."
                            docker cp /var/jenkins_home/workspace/Dictionary-app/. dictionary_web:/var/www/html/
                            
                            echo "Setting permissions..."
                            docker exec dictionary_web chown -R www-data:www-data /var/www/html
                            
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
                if [ -d "/var/jenkins_home/workspace/Dictionary-app" ]; then
                    cd /var/jenkins_home/workspace/Dictionary-app
                    docker-compose down || true
                fi
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        always {
            echo 'Pipeline finished'
        }
    }
}
