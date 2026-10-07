pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins',
                    url: 'https://github.com/Patricia406/evaluacion-devops-backend.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Validate Project') {
            steps {
                sh 'node --version'
                sh 'npm --version'
            }
        }
    }

    post {
        success {
            echo 'Pipeline ejecutado correctamente'
        }

        failure {
            echo 'Pipeline finalizado con errores'
        }
    }
}