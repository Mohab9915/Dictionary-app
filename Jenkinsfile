pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('Setup Dependencies') {
            steps {
                sh '''
                    if ! command -v docker &> /dev/null; then
                        echo "Docker not found, installing..."
                        apt-get update
                        apt-get install -y docker.io
                    fi
                    
                    if ! command -v docker-compose &> /dev/null; then
                        echo "Installing docker-compose..."
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
                    # Force stop and remove containers if they exist
                    docker ps -q --filter "name=dictionary_web" | xargs -r docker stop
                    docker ps -q --filter "name=dictionary_db" | xargs -r docker stop
                    docker ps -a -q --filter "name=dictionary_web" | xargs -r docker rm -f
                    docker ps -a -q --filter "name=dictionary_db" | xargs -r docker rm -f
                    
                    # Remove old images
                    docker images -q dictionary-web | xargs -r docker rmi -f
                    
                    # Prune unused resources
                    docker system prune -f
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    try {
                        sh '''
                            mkdir -p /var/jenkins_home/workspace/Dictionary-app
                            rm -rf /var/jenkins_home/workspace/Dictionary-app/*
                            rm -rf /var/jenkins_home/workspace/Dictionary-app/.git
                            
                            cd /var/jenkins_home/workspace/Dictionary-app
                            
                            git init
                            git remote add origin https://github.com/Mohab9915/Dictionary-app.git
                            git fetch origin main
                            git checkout -f main
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
                            
                            if [ ! -f docker-compose.yml ]; then
                                echo "docker-compose.yml not found!"
                                exit 1
                            fi
                            
                            # Build and start containers
                            docker-compose build --no-cache web db
                            docker-compose up -d web db
                            
                            # Wait for containers to be ready
                            echo "Waiting for containers to start..."
                            sleep 20
                            
                            # Verify containers are running
                            if ! docker ps | grep -q dictionary_web || ! docker ps | grep -q dictionary_db; then
                                echo "Containers failed to start properly"
                                exit 1
                            fi
                            
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
                cd /var/jenkins_home/workspace/Dictionary-app || true
                docker-compose down || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        always {
            sh '''
                # Ensure workspace is clean
                rm -rf /var/jenkins_home/workspace/Dictionary-app/* || true
            '''
        }
    }
}
