pipeline {
  agent any
  options {
    disableConcurrentBuilds()
    ansiColor('vga')
  }
  triggers {
    pollSCM 'H/15 * * * *'
  }
  stages {
    stage ("Build Environment") {
      steps {
        sh '''
          source /opt/venvs/ansible/bin/activate
          python -V
          ansible --version
          molecule --version
        '''
      }
    }
    stage ("Syntax") {
      steps {
        sh '(source /opt/venvs/ansible/bin/activate && cd roles/nginx && molecule syntax)'
      }
    }
    stage ("Linting") {
      steps {
        sh '(source /opt/venvs/ansible/bin/activate && cd roles/nginx && molecule lint)'
      }
    }
    stage ("Playbook") {
      steps {
        sh '(source /opt/venvs/ansible/bin/activate && cd roles/nginx && molecule converge)'
      }
    }
    stage ("Verification") {
      steps {
        sh '(source /opt/venvs/ansible/bin/activate && cd roles/nginx && molecule verify)'
      }
    }
    stage ("Idempotency") {
      steps {
        sh '(source /opt/venvs/ansible/bin/activate && cd roles/nginx && molecule idempotence)'
      }
    }
  }
}
