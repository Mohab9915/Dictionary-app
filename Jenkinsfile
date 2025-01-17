pipeline{
    agent any
    stages {
        stage('Setup Dependencies'){
            steps{
                sh"
                if !command -v
                docker-compose &> /dev/null; then
                echo "installing docker-compose"
                apt-get update
                apt-get install -y docker.io curl git
                chmod +x /usr/local/bin/docker-compose
                else
                echo "docker-compose already installed"
                docker-compose --version
                fi
                "

            }
        }

        stage('Cleanup'){
            steps{
                sh"
                echo "cleaning up..."
                docker-compose down
                db web || true
                docker system prune -f
                "
            }
        }

        stage('Clone Repository'){
            steps {
                try{

                
                sh "
                rm -r /var/jenkins_home/workspace/Dictionary-app
                cd /var/jenkins_home/workspace
                git clone 'https://github.com/Mohab9915/Dictionary-app.git'
                "
                }
                catch (Exception e){
                        error "Failed to clone repository: ${e.getMessage()}"
                    }
            }
        }
        
        stage('Build and Deploy'){
            steps{
                script{
                    try{
                        sh"
                        cd /var/jenkins_home/workspace/Dectionary-app
                        docker-compose build web db
                         docker-compose up build web db
                         echo "waiting containers to start"
                         sleep 15
                         echo "container status"
                         docker-compose ps
                        "
                    }
                    catch (Exception e) {
                        error "Deployment failed: ${e.getMessage()}"
                    }
                }

            }
        }
        
       post{
        failure{
            sh"
            echo "pipeline fail .. cleaning up "
            cd /var/jenkins_home/workspace/Dictionary-app
            docker-compose down || true
            "
        }
        success{
            echo "pipeline completed successfully."
        }
       }
    }
}