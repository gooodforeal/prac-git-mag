pipeline {
  agent any

  triggers {
    pollSCM('* * * * *')
  }

  environment {
    ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    IMAGE = "todo-app:${BUILD_NUMBER}"
    CONTAINER = "todo-app"
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
          test -f app.py
          test -f requirements.txt
          test -f Dockerfile
          test -f deploy.yml
          grep -q "Flask" requirements.txt
          python3 -m py_compile app.py
          echo "Проверки исходников пройдены"
        '''
      }
    }

    stage('Build') {
      steps {
        sh '''
          set -e
          if ! sudo docker image inspect python:3.12-slim >/dev/null 2>&1; then
            for i in 1 2 3 4 5; do
              sudo docker pull python:3.12-slim && break
              echo "pull attempt $i failed"
              sleep 3
            done
          fi

          ok=0
          for i in 1 2 3 4 5; do
            if DOCKER_BUILDKIT=0 sudo docker build --pull=false -t "${IMAGE}" -t todo-app:latest .; then
              ok=1
              break
            fi
            echo "build attempt $i failed"
            sleep 3
          done
          test "$ok" = "1"
          sudo docker images "${IMAGE}"
          echo "Образ собран на master"
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh 'ansible-playbook -i inventory.ini deploy.yml -e "image=${IMAGE} container_name=${CONTAINER}"'
      }
    }

    stage('Smoke') {
      steps {
        sh '''
          sleep 2
          curl -sf http://node1:5000/health | grep -q ok
          curl -sf http://node1:5000/ | grep -q "Список задач"
          echo "Flask-приложение отвечает на node1"
        '''
      }
    }
  }
}
