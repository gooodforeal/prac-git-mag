pipeline {
  agent any

  triggers {
    pollSCM('* * * * *')
  }

  environment {
    ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    IMAGE = "webapp:${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: 'https://github.com/gooodforeal/prac-git-mag.git'
      }
    }

    stage('Test') {
      steps {
        sh '''
          test -f index.html
          test -f Dockerfile
          test -f deploy.yml
          test -f inventory.ini
          grep -q "Hello World" index.html
          echo "Проверки исходников пройдены"
        '''
      }
    }

    stage('Build') {
      steps {
        sh '''
          mkdir -p build
          cp index.html build/index.html
          echo "<p>CI/CD build #${BUILD_NUMBER} ($(date))</p>" >> build/index.html
          cp build/index.html index.html

          if command -v docker >/dev/null 2>&1 || command -v sudo >/dev/null 2>&1; then
            sudo docker build -t "${IMAGE}" .
            sudo docker images "${IMAGE}"
          else
            echo "Docker CLI недоступен — собрали только HTML-артефакт"
          fi

          echo "Сборка готова"
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh 'ansible-playbook -i inventory.ini deploy.yml'
      }
    }

    stage('Smoke') {
      steps {
        sh '''
          sleep 2
          curl -sf http://node1 | grep -q "Hello World"
          echo "Сайт на node1 отвечает"
        '''
      }
    }
  }
}
