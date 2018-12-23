pipeline {
    agent none
    stages {
        stage('Build images') {
            parallel {
                stage('build') {
                    agent { dockerfile { dir 'build' } }
                    steps {
                        sh 'du -hxd 3 /'
                    }
                }
                stage('text') {
                    agent { dockerfile { dir 'text' } }
                    steps {
                        sh 'du -hxd 3 /'
                    }
                }
            }
        }
    }
}