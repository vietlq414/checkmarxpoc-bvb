def repoImage="easybug"
def repoContainerName="easy-buggy"
def repoRegistry = "easybug/${repoImage}"
def dockerrepoImage = ''
def lastSuccessfulBuildID  = 0

node ("jenkins-local-agent"){
    try {
      def MY_REPO = checkout scm

    // stage('scan') {
    // bat """
    //   java -Xms512m -Xmx1024m ^
    //   -Djavax.net.debug=ssl,handshake ^
    //   -jar "C:\\Software\\cxflow\\cx-flow.jar" --spring.config.location=C:\\Software\\cxflow\\application.yml ^
    //   --scan ^
    //   --cx-project="cx-demo-webgoat" ^
    //   --app="cx-demo-webgoat-master" ^
    //   --branch="master" ^
    //   --repo-name="cx-demo-webgoat" ^
    //   --namespace="security" ^
    //   --cx-flow.break-build="true" ^
    //   --f=.
    // """
    // }
    stage('Chekcmarx CxSAST scan with Jenkins Plugins'){
      step([
        $class: 'CxScanBuilder', 
        comment: '', 
        configAsCode: true, 
        credentialsId: '', 
        customFields: '', 
        excludeFolders: '', 
        exclusionsSetting: 'global',
        failBuildOnNewResults: false, 
        failBuildOnNewSeverity: 'HIGH', 
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
        groupId: '1', 
        incremental: true, 
        password: '{AQAAABAAAAAQ3lgyOVHPRUbdmnV4idnGOLPhNp4aFP5LXPwkR0IC2R0=}', 
        postScanActionId: 1, 
        preset: '0', 
        projectLevelCustomFields: '', 
        projectName: 'checkmarxpoc-bvb', 
        sastEnabled: true, 
        serverUrl: 'https://checkmarx.viettelidc.lab/', 
        sourceEncoding: '1', 
        username: '', 
        vulnerabilityThresholdResult: 'FAILURE', 
        waitForResultsEnabled: true])
    }

    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {

    }
}