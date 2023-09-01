pipeline {
    agent any
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
                sh "docker build -t mon_image_en_dur ."
            }
        }
        stage('clear docker containers') {
            steps {
                CONTAINERS = sh (
                    script: 'docker ps -a -q --filter ancestor=mon_image_en_dur',
                    returnStdout: true
                ).trim()
                
                sh "docker stop $CONTAINERS"
                sh "docker rm $CONTAINERS"
            }
        }
        stage('run !') {
            steps {
                echo "run docker image ..."
                sh "docker run -d mon_image_en_dur"
            }
        }
    }
}