pipeline {
    agent { label 'with_docker' }

    environment {
        APP_NAME = 'mon_appli'
        CONTAINERS = sh (
            script: 'docker ps -a -q --filter ancestor=mon_appli',
            returnStdout: true
        ).trim()
    }

    stages {
        stage('init') {
            steps {
                echo "pipeline init ..."
            }
        }
        stage('minify code') {
            steps {
                sh "docker run -v ${workspace}/src:/src -v ${workspace}/static:/static -v ${workspace}/scripts:/scripts alpine:latest sh /scripts/minify.sh"
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
                allOf {
                    expression {
                        currentBuild.result == null || currentBuild.result == 'SUCCESS' 
                    }
                    expression {
                        env.CONTAINERS != null
                    }
                }
            }
            steps {
                sh "docker stop $CONTAINERS"
                sh "docker rm $CONTAINERS"

            }
        }
        stage('clear old images') {
            steps {
                sh "docker rmi $APP_NAME"
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