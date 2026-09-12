pipeline {
  agent any

  triggers {
    cron('H/15 * * * *')
  }

  environment {
    ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: 'https://github.com/gooodforeal/prac-git-mag.git'
      }
    }

    stage('Build') {
      steps {
        sh '''
          mkdir -p build
          cp index.html build/index.html
          echo "<p>Jenkins build #${BUILD_NUMBER} ($(date))</p>" >> build/index.html
          cp build/index.html index.html
          echo "Сборка готова"
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh 'ansible-playbook -i inventory.ini deploy.yml'
      }
    }
  }
}
