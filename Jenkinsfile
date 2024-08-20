def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
        def MY_REPO = checkout scm

        stage('Unit Test') {
            steps {
                mvn clean test package
            }
        }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {

    }
}