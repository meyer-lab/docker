pipeline {
    agent none
    stages {
        parallel {
            stage('build image') {
                agent { dockerfile { dir 'build' } }
                steps {
                    sh 'du -hxd 3 /'
                }
            }
            stage('text image') {
                agent { dockerfile { dir 'text' } }
                steps {
                    sh 'du -hxd 3 /'
                }
            }
        }
    }
}