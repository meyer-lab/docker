node {
    checkout scm
    def textImage = docker.build("text", "./text") 
    def buildImage = docker.build("build", "./build") 

    textImage.inside {
        sh 'echo Done'
    }
    buildImage.inside {
        sh 'echo Done'
    }
    
    stage('Push images') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            textImage.push("${env.BUILD_NUMBER}")
            textImage.push("latest")
            
            buildImage.push("${env.BUILD_NUMBER}")
            buildImage.push("latest")
        }
    }
}
