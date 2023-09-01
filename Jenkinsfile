pipeline {
    agent any
    environment {
        APP_NAME = 'mon_appli'
    }
    stages {
        stage('init') {
            steps {
                echo "pipeline init ..."
            }
        }
        stage('build docker image') {
            when { expression { return fileExists ('Dockerfile') } }
            steps {
                echo "Dockerfile found, building image ..."
                sh "docker build -t \$APP_NAME ."
            }
        }
        stage('clear docker containers') {
            steps {
                CONTAINERS = sh (
                    script: 'docker ps -a -q --filter ancestor=\$APP_NAME',
                    returnStdout: true
                ).trim()
                
                sh "docker stop $CONTAINERS"
                sh "docker rm $CONTAINERS"
            }
        }
        stage('run !') {
            steps {
                echo "run docker image ..."
                sh "docker run -d -p 4380:4380 \$APP_NAME"
            }
        }
    }
}