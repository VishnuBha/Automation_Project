pipeline {
  agent any
  stages {
    stage('first stage') {
      parallel {
        stage('first stage') {
          steps {
            sh 'echo hi'
          }
        }

        stage('prallel Stage') {
          steps {
            sh 'echo hi'
          }
        }

      }
    }

    stage('second stage') {
      steps {
        sh 'echo hloooooooo'
      }
    }

  }
  environment {
    Sample = 'Value'
    Second = 'value2'
  }
}