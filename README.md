# Dictionary App #

A containerized web application that finds matching words using PHP, MySQL, and Docker.

## Features ##

- Word matching lookup
- Containerized application using Docker
- Automated deployment with Jenkins
- Interactive deployment script
- GitHub integration

## Prerequisites

- Docker
- Docker Compose
- Git
- Jenkins (optional)

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/Mohab9915/Dictionary-app.git
cd Dictionary-app
```

2. Run the deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

3. Access the application:
- Dictionary App: http://localhost:8080
- Jenkins: http://localhost:8081

## Manual Setup

1. Build and start containers:
```bash
docker-compose build
docker-compose up -d
```

2. Stop containers:
```bash
docker-compose down
```

## Project Structure ##

```
Dictionary-app/
├── docker-compose.yml     # Container orchestration
├── Dockerfile            # PHP container configuration
├── index.php            # Main application
├── config.php           # Database configuration
├── script.js            # Frontend JavaScript
├── style.css            # CSS styles
├── dictionary_db/       # Database initialization
├── Jenkinsfile         # CI/CD pipeline
└── deploy.sh           # Deployment script
```

## Database

The application uses MySQL 5.7 with sample word pairs. Default credentials:
- Host: db
- User: root
- Password: (empty)
- Database: dictionary_db

## Jenkins Pipeline

The included Jenkinsfile provides:
- Dependency setup
- Repository cloning
- Docker container management
- Automated deployment

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request
