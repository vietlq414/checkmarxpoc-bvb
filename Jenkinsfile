def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
      def MY_REPO = checkout scm
      stage('Run Uni Test'){
        bat """
          mvn clean test package
        """
      }
      stage('Run SAST Scan with CxFlow') {
        bat """
          java -Xms512m -Xmx1024m \
          -Djava.security.egd="file:/dev/./urandom" \
          -Djavax.net.debug=ssl,handshake \
          -jar "C:\\Software\\cxflow\\cx-flow.jar" --spring.config.location=./application.yml \
          --scan \
          --cx-project="cx-demo-webgoat" \
          --app="cx-demo-webgoat-master" \
          --branch="master" \
          --repo-name="cx-demo-webgoat" \
          --namespace="security" \
          --cx-flow.break-build="true" \
          --f=.
        """
      }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {

    }
}