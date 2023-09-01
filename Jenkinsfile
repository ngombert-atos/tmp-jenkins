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
                sh "docker build -t \$APP_NAME:\$BRANCH_NAME-\$BUILD_NUMBER ."
            }
        }
        stage('clear docker containers') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                script {
                    CONTAINERS = sh (
                        script: 'docker ps -a -q --filter ancestor=\$APP_NAME',
                        returnStdout: true
                    ).trim()
                }

                sh "docker stop $CONTAINERS"
                sh "docker rm $CONTAINERS"
                sh "docker rmi $\APP_NAME"
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