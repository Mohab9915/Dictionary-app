#!/bin/bash

echo "Dictionary App Deployment Script"
echo "------------------------------"

deploy_app() {
    echo "Cleaning up..."
    docker-compose down

    echo "Building and starting services..."
    docker-compose build 
    docker-compose up -d

    echo "Waiting for services to start..."
    sleep 15

    echo "Service Status:"
    docker-compose ps
}

upload_to_github() {
    echo "Uploading to GitHub..."
    
    git config --global user.email "mohabhae9915@gmai.com"
    git config --global user.name "Mohab9915"
    
    git add .
    git commit -m "Auto-update: $(date '+%Y-%m-%d %H:%M:%S')"
    
    if git push origin main; then
        echo "✓ Upload complete!"
    else
        echo "× Upload failed!"
    fi
}

echo "1. Deploy application only"
echo "2. Deploy and upload to GitHub"
read -p "Choose an option (1 or 2): " choice

case $choice in
    1)
        deploy_app
        echo "
-------------------------------------
Dictionary App is ready!
Web App: http://localhost:8080
Jenkins: http://localhost:8081
-------------------------------------"
        ;;
    2)
        deploy_app
        upload_to_github
        echo "
-------------------------------------
Dictionary App is ready!
Web App: http://localhost:8080
Jenkins: http://localhost:8081
-------------------------------------"
        ;;
    *)
        echo "Invalid option. Please choose 1 or 2."
        exit 1
        ;;
esac
