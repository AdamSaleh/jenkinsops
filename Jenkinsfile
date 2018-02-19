node {
  stage ('Build') { 
    step([$class: 'WsCleanup'])
    checkout scm
    sh 'nikola build' 
  }
}
