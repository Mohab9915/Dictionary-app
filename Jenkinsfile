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
                    docker-compose down db web|| true
                    docker system prune -f
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
                            
                            git clone https://github.com/Mohab9915/Dictionary-app.git /var/jenkins_home/workspace/Dictionary-app


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
                            
                            # Stop and remove existing containers
                            docker-compose down
                            
                            # Remove old web container and image to force rebuild
                            docker rm -f dictionary_web || true
                            docker rmi dictionary-app_web || true
                            
                            # Build and start containers
                            docker-compose build --no-cache web
                            docker-compose up -d web db
                            
                            # Ensure the web container is running
                            until [ "`docker inspect -f {{.State.Running}} dictionary_web`" == "true" ]; do
                                echo "Waiting for web container to start..."
                                sleep 2
                            done
                            
                            # Copy updated files to web container
                            echo "Copying files to web container..."
                            docker cp ./* dictionary_web:/var/www/html/
                            docker cp ./.* dictionary_web:/var/www/html/ 2>/dev/null || true
                            
                            # Set proper permissions
                            echo "Setting permissions..."
                            docker exec dictionary_web chown -R www-data:www-data /var/www/html
                            docker exec dictionary_web chmod -R 755 /var/www/html
                            
                            # Verify the file was updated
                            echo "Verifying index.html content:"
                            docker exec dictionary_web cat /var/www/html/index.html
                            
                            # Restart Apache in the container
                            echo "Restarting Apache..."
                            docker exec dictionary_web service apache2 reload
                            
                            echo "Waiting for services to stabilize..."
                            sleep 5
                            
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
