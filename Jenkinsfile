node {
    checkout scm

    def buildImage = docker.build("build:${env.BUILD_ID}", "build/")

    buildImage.inside {
        sh 'du -hxd 3 /'
    }

    def textImage = docker.build("text:${env.BUILD_ID}", "text/")

    textImage.inside {
        sh 'du -hxd 3 /'
    }
}
