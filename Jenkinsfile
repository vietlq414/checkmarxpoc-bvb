def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
      def MY_REPO = checkout scm
      stages {
        stage('Run Command') {
            steps {
                bat 'echo Hello, World!'
                // Replace 'echo Hello, World!' with your desired command
            }
        }
      }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {

    }
}