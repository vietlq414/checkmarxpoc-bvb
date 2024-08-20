def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
        def MY_REPO = checkout scm
        def GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD')
        def IMAGE_TAG = GIT_COMMIT.take(7)

        stage('Clean Repository') {
            sh """
                rm -rf *.zip *.gz
                rm -rf kics-*
                rm -rf *.json
                rm -rf cyclonedx-kics-results.xml junit-kics-results.xml
            """
        }

        stage('Unit Test') {
            docker.image('maven:3.6.3-jdk-8').inside('-v $HOME/.m2:/root/.m2') {
                sh """
                    mvn test
                """
            }
        }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {

    }
}