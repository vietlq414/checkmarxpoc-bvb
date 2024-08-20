def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
        def MY_REPO = checkout scm

        stage('Clean Repository') {
            sh """
                rm -rf *.zip *.gz
                rm -rf kics-*
                rm -rf *.json
                rm -rf cyclonedx-kics-results.xml junit-kics-results.xml
            """
        }

        stage('Unit Test') {
            docker.image('maven:3.6.3-jdk-8') {
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