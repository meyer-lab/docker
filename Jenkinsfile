pipeline {
    agent { dockerfile true }
    stages {
        stage('Test') {
            steps {
                sh 'python3 --version'
                sh 'clang --version'
                sh 'du --max-depth=1 -x *'
            }
        }
    }
}
