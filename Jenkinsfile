node {
  result="SUCCESS"
  color="GREEN"
  notify=false
  message="No special message"
  try {
    dockerhub_repo = 'fxinnovation/pythonlinters'
    ansiColor('xterm') {
      stage('checkout') {
        // Checking out scm
        checkout scm
        // Getting current commit sha1
        commit_id = sh(
          returnStdout: true,
          script: "git rev-parse HEAD"
        ).trim()
        // Getting current tag or commit sha1
        tag_id = sh(
          returnStdout: true,
          script: "git describe --tags --exact-match || git rev-parse HEAD"
        ).trim()
        // Getting scm url
        scm_url = sh(
          returnStdout: true,
          script: "git config --get remote.origin.url"
        ).trim()
      }
      stage('pre-build') {
        // Verifying docker is up and running
        sh 'docker --version && docker images'
      }
      stage("build") {
        // Building Docker Image
        sh "docker build \
             --label \"org.label-schema.vcs-ref\"=\"${commit_id}\" \
             --label \"org.label-schema.version\"=\"${tag_id}\" \
             --label \"org.label-schema.build-date\"=\"\$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")\" \
             --label \"org.label-schema.usage\"=\"${scm_url}/src?at=${tag_id}\" \
             -t ${dockerhub_repo}:${tag_id} ."
      }
      stage("test") {
        // Testing Image Works
        sh "docker run ${dockerhub_repo}:${tag_id} pylint --version"
        sh "docker run ${dockerhub_repo}:${tag_id} mypy --version"
        sh "docker inspect ${dockerhub_repo}:${tag_id}"
        message = "Docker build is successfull"
      }
    }
  }catch (error){
    result="FAILED"
    color="RED"
    notify=true
    message=error
    throw (error)
  }finally {
    stage("notify"){
      hipchatSend (
        color: color,
        credentialId: 'jenkins-hipchat-token',
        message: "Job Name: ${JOB_NAME} (<a href=\"${BUILD_URL}\">Open</a>)<br /> \
                  Job Status: ${result} <br /> \
                  Job Message: <br /><pre>${message}</pre>",
        room: '942680',
        notify: notify,
        sendAs: 'New-Jenkins',
        server: 'api.hipchat.com',
        v2enabled: false
      )
    }
  }
}
