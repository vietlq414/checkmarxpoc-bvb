def BUILD_NODE = 'jenkins-local-agent'
def PROJECT = params.PROJECT
def PROJECT_NAME = PROJECT.replace('.', '-')
def BUILD_MODE = params.BUILD_MODE
def DOCKERFILE_TEMPLATE = 'Dockerfile_template'
def BUILD_NUMBER = currentBuild.number
def PORT = [
  'Automation.Admin': '8000',
  'Automation.Affiliate.Web': '8010',
  'Automation.Api': '8020',
  'Automation.API.BillingService': '8030',
  'Automation.API.OrderService': '8040',
  'Automation.ApiCore': '8050',
  'Automation.CMP.Api': '8060',
  'Automation.RMS.Web': '8070',
  'Automation.VCS.ApiCore': '8080',
  'Automation.Website': '8090'
]

println 'BUILD_NUMBER: ' + BUILD_NUMBER
println 'BUILD PROJECT: ' + PROJECT
println 'PROJECT_NAME: ' + PROJECT_NAME
println 'BUILD MODE: ' + BUILD_MODE
println 'CONTAINER RUN ON PORT: ' + PORT[PROJECT]

//Jenkins's credential
def CredentialsId = 'admin'

//Define image's name
def artifactImage = PROJECT.replace('Automation.', '').toLowerCase()
def artifactImage_TAG = artifactImage + ':' + BUILD_NUMBER
println 'artifactImage_TAG: ' + artifactImage_TAG

//Define container's name
def gatewayContainerName = PROJECT.replace('Automation.', '').toLowerCase()
println 'gatewayContainerName: ' + gatewayContainerName

def artifactCredentialIds = 'admin_jfrog'

//Define Jfrog's repo information
def artifactHost = '172.16.90.130:8082'
def artifactRepo = 'storage'

node(BUILD_NODE) {
    try {
      stage('Step 1. Checkout git') {
          checkout scm
      }
      stage('Step 2: Checkmarx Scan Security'){
        step(
          [
            $class: 'CxScanBuilder', 
            avoidDuplicateProjectScans: true, 
            comment: '', 
            credentialsId: '', 
            customFields: '', 
            enableProjectPolicyEnforcement: true, 
            excludeFolders: '', 
            exclusionsSetting: 'global', 
            failBuildOnNewResults: false, 
            filterPattern: '''!**/_cvs/**/*, !**/.svn/**/*, !**/.hg/**/*, !**/.git/**/*, !**/.bzr/**/*,
            !**/.gitgnore/**/*, !**/.gradle/**/*, !**/.checkstyle/**/*, !**/.classpath/**/*, !**/bin/**/*,
            !**/obj/**/*, !**/backup/**/*, !**/.idea/**/*, !**/*.DS_Store, !**/*.ipr, !**/*.iws,
            !**/*.bak, !**/*.tmp, !**/*.aac, !**/*.aif, !**/*.iff, !**/*.m3u, !**/*.mid, !**/*.mp3,
            !**/*.mpa, !**/*.ra, !**/*.wav, !**/*.wma, !**/*.3g2, !**/*.3gp, !**/*.asf, !**/*.asx,
            !**/*.avi, !**/*.flv, !**/*.mov, !**/*.mp4, !**/*.mpg, !**/*.rm, !**/*.swf, !**/*.vob,
            !**/*.wmv, !**/*.bmp, !**/*.gif, !**/*.jpg, !**/*.png, !**/*.psd, !**/*.tif, !**/*.swf,
            !**/*.jar, !**/*.zip, !**/*.rar, !**/*.exe, !**/*.dll, !**/*.pdb, !**/*.7z, !**/*.gz,
            !**/*.tar.gz, !**/*.tar, !**/*.gz, !**/*.ahtm, !**/*.ahtml, !**/*.fhtml, !**/*.hdm,
            !**/*.hdml, !**/*.hsql, !**/*.ht, !**/*.hta, !**/*.htc, !**/*.htd, !**/*.war, !**/*.ear,
            !**/*.htmls, !**/*.ihtml, !**/*.mht, !**/*.mhtm, !**/*.mhtml, !**/*.ssi, !**/*.stm,
            !**/*.bin,!**/*.lock,!**/*.svg,!**/*.obj,
            !**/*.stml, !**/*.ttml, !**/*.txn, !**/*.xhtm, !**/*.xhtml, !**/*.class, !**/*.iml, !Checkmarx/Reports/*.*,
            !OSADependencies.json, !**/node_modules/**/*, !**/.cxsca-results.json, !**/.cxsca-sast-results.json, !.checkmarx/cx.config''', 
            fullScanCycle: 10, 
            generatePdfReport: true, 
            groupId: '7', incremental: true, 
            jobStatusOnError: 'FAILURE', 
            password: '{AQAAABAAAAAQLjGo/RAfdWvYMRFP+P4xCyNOalRTJOfRtKuKeFamuH4=}', 
            preset: '0', 
            projectLevelCustomFields: '', 
            projectName: 'cx-easybuggy', 
            projectRetentionRate: 10, 
            sastEnabled: true, 
            serverUrl: 'https://cxapactrial.checkmarx.net/', 
            sourceEncoding: '7', 
            username: '', 
            waitForResultsEnabled: true
          ]
        )
      }

        stage('Step 3. Generate Dockerfile from tempalte') {
            try {
                def Dockerfile_content = ReadTextFile(DOCKERFILE_TEMPLATE)
                Dockerfile_content = Dockerfile_content.replace('{PROJECT}', PROJECT).replace('{PROJECT_NAME}', PROJECT_NAME).replace('{BUILD_MODE}', BUILD_MODE)
                WriteTextFile('Dockerfile', Dockerfile_content)
            } catch (Exception e) {
                println 'Generate Dockerfile fail.\n' + e.toString()
                throw e
            }
        }

        stage('Step 4. Build image') {
            try {
                def dockerartifactImage = docker.build(artifactImage_TAG, '-f Dockerfile .')
                bat('docker images')
            } catch (Exception e) {
                println 'Build fail.\n' + e.toString()
                throw e
            }

        }

        stage('Step 5. Push image to artifactory') {
            try {
                bat('docker tag ' + artifactImage_TAG + ' ' + artifactHost + '/' + artifactRepo + '/' + artifactImage_TAG)
                // Login Artifactory
                withCredentials([usernamePassword(credentialsId: artifactCredentialIds, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                //println('RUNNING: docker login -u ' + USERNAME + ' -p ' + PASSWORD + ' ' + artifactHost)
                bat('docker login -u ' + USERNAME + ' -p ' + PASSWORD + ' ' + artifactHost + '/' + artifactRepo)
                }
                bat('docker push ' + artifactHost + '/' + artifactRepo + '/' + artifactImage_TAG)
            } catch (e) {
                println 'Push image exception.\n' + e.toString()
            }
        }

        stage('Step 6. Pull image from artifactory') {
            if (!BUILD_NODE.equals(DEPLOY_NODE))
                try {
                    println 'pull image from Artifactory'
                    // Login Artifactory
                    withCredentials([usernamePassword(credentialsId: artifactCredentialIds, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        bat('docker login -u ' + USERNAME + ' -p ' + PASSWORD + ' ' + artifactHost)
                    }
                    bat('docker pull ' + artifactHost + '/' + artifactRepo + '/' + artifactImage_TAG)
                    bat('docker tag ' + artifactHost + '/' + artifactRepo + '/' + artifactImage_TAG + ' ' + artifactImage_TAG)
                    } catch (e) {
                        println 'pull image fail! '
                }
        }

        stage('Step 6. Delete Docker Container if exists') {
            // stop and remove logs container
            try {
                bat('docker container stop ' + gatewayContainerName)
                bat('docker container rm ' + gatewayContainerName)
                println 'Delete ' + gatewayContainerName + ' done'
            } catch (Exception e) {
                println gatewayContainerName + ' not exists or not running' + e.toString()
            }
        }

        stage('Step 7. Run Docker Image') {
            try {
                bat('docker run -d -p ' + PORT[PROJECT] + ':80 --name=' + gatewayContainerName + ' --restart=always ' + artifactImage_TAG + ' -v //c/Jenkins/atm_build/atm_website://c/inetpub/wwwroot')
            } catch (e) {
                println 'Run ' + gatewayContainerName + ' failed'
            }
        }

        stage('Step 8. Delete Docker Image') {
            try {
                println 'Tam thoi disable de test'
                //bat( 'docker image rm -f ' + artifactImage_TAG)
                //bat( 'docker image rm -f ' + artifactHost + '/' + artifactRepo + '/' + artifactImage_TAG)
                //println 'Delete image ' + artifactImage_TAG + ' successful'
            } catch (Exception e) {
                println ' Image  ' + artifactImage_TAG + ' is not deleted' + e.toString()
            }
        }
        
    } catch (e) {
        currentBuild.result = 'FAILED' + e.toString()
        println 'FAILED:+\n'
        e.toString()
        return;
    }
}

def String ReadTextFile(def fileName) {
    try {
        stage('Read file: ' + fileName) {
            def data = readFile(file: fileName)
            //println(data)
            return data
        }
    } catch (e) {
        throw e
    }
}

def WriteTextFile(def fileName, def data) {
    try {
        stage('Write file: ' + fileName) {
            writeFile(file: fileName, text: data)
        }
    } catch (e) {
        throw e
    }
}