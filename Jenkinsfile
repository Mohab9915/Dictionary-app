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
                    docker-compose down db web || true
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
                            
                            rm -rf /var/jenkins_home/workspace/Dictionary-app/*
                            rm -rf /var/jenkins_home/workspace/Dictionary-app/.git
                            
                            cd /var/jenkins_home/workspace/Dictionary-app
                            
                            git init
                            git remote add origin https://github.com/Mohab9915/Dictionary-app.git
                            git fetch origin main
                            git checkout -f main
                            
                            git status
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
                            pwd
                            ls -la
                            
                            if [ ! -f docker-compose.yml ]; then
                                echo "docker-compose.yml not found!"
                                exit 1
                            fi
                            
                            docker-compose build web db
                            docker-compose up -d web db
                            
                            echo "Copying files to web container..."
                            docker cp . dictionary_web:/var/www/html/
                            
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
                    if [ -f docker-compose.yml ]; then
                        docker-compose down || true
                    fi
                fi
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        always {
            cleanWs(cleanWhenNotBuilt: false,
                   deleteDirs: true,
                   disableDeferredWipeout: true,
                   notFailBuild: true)
        }
    }
}
