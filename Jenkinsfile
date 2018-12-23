pipeline {
    agent none
    stages {
        stage('Build images') {
            parallel {
                stage('build') {
                    agent { dockerfile { dir 'build' } }
                    steps {
                        sh 'echo Done'
                    }
                }
                stage('text') {
                    agent { dockerfile { dir 'text' } }
                    steps {
                        sh 'echo Done'
                    }
                }
            }
        }
    }
}