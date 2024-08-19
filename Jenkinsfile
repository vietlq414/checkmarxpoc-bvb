def label = "kube-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,

  containers: [
    containerTemplate( name: 'maven', image: 'maven:3.6.3-jdk-8', command: 'cat', ttyEnabled: true, privileged: true),
    containerTemplate(name: 'buildah', image: 'buildah:latest', command: 'cat', ttyEnabled: true, workingDir: '/home/nonroot/app',privileged: true),
    containerTemplate(name: 'helm', image: 'helm:latest', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'cxflow', image: 'cxflow:latest', command: 'crmat', ttyEnabled: true),
    containerTemplate(name: 'jnlp', image: 'jnlp-slave:latest', args: '${computer.jnlpmac} ${computer.name}',
        envVars: [envVar(key: 'JENKINS_URL', value: 'http://kubernetes.docker.internal:9090')])
  ],
  volumes: [
    secretVolume(mountPath: '/root/.docker/',secretName: 'my-registry-key'),
  ]
)
{
  node(label) {
    
    def myRepo = checkout scm
    def GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD')
    def IMAGE_TAG = GIT_COMMIT.take(7)
    def REGISTRY_URL = "docker.io"
    def IMAGE = "n3wbiegt/easybuggy"
    def NEW_IMAGE_TAG = "${REGISTRY_URL}/${IMAGE}:${IMAGE_TAG}"
    def LATEST_IMAGE_TAG = "${REGISTRY_URL}/${IMAGE}:latest"
    def CHART_FOLDER = 'helm-chart'
    def APP_NAME = "easybuggy"
    def NAMESPACE="default"

    container('maven') {
      stage('mvn build service'){
        sh """
          mvn clean test package
          ls -ltr
        """
      }
    }
    container('cxflow'){
      stage('sast sca'){
        sh """
          java -Xms512m -Xmx1024m \
          -Djava.security.egd="file:/dev/./urandom" \
          -Djavax.net.debug=ssl,handshake \
          -jar /app/cx-flow.jar --spring.config.location=./application.yml \
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
    }
    container('buildah') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'docker-hub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD']]){
        stage('Build docker image') {
            sh """
              buildah login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${REGISTRY_URL}
              """
            sh """       
              buildah bud --format docker -t ${NEW_IMAGE_TAG} .
              buildah push ${NEW_IMAGE_TAG}

              buildah tag ${NEW_IMAGE_TAG} ${LATEST_IMAGE_TAG}
              buildah push ${LATEST_IMAGE_TAG}
            """
        }
      }
    }
    container('helm') {
      stage('Release to helm repository') {
        sh """
          helm version
          cd ${CHART_FOLDER}
          sed -i "s/1.0.0/${IMAGE_TAG}/" values.yaml       
          cd ../
          helm lint ./${CHART_FOLDER}
          helm template ${APP_NAME} ./${CHART_FOLDER}
          helm package ./${CHART_FOLDER}
          helm upgrade --install --set image.tag=${IMAGE_TAG} ${APP_NAME} ./${CHART_FOLDER} -n ${NAMESPACE}
        """
      }
    }
  }
}
