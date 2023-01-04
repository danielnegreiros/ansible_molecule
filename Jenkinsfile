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
          source /home/daniel/py_venvs/ansible/bin/activate
          python -V
          ansible --version
          molecule --version
        '''
      }
    }
    stage ("Syntax") {
      steps {
        sh '(source /home/daniel/py_venvs/ansible/bin/activate && molecule syntax)'
      }
    }
    stage ("Linting") {
      steps {
        sh '(source /home/daniel/py_venvs/ansible/bin/activate && molecule lint)'
      }
    }
    stage ("Playbook") {
      steps {
        sh '(source /home/daniel/py_venvs/ansible/bin/activate && molecule converge)'
      }
    }
    stage ("Verification") {
      steps {
        sh '(source /home/daniel/py_venvs/ansible/bin/activate && molecule verify)'
      }
    }
    stage ("Idempotency") {
      steps {
        sh '(source /home/daniel/py_venvs/ansible/bin/activate && molecule idempotence)'
      }
    }
  }
}
