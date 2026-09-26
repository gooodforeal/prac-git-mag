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
          sudo docker build -t "${IMAGE}" -t todo-app:latest .
          sudo docker images "${IMAGE}"
          echo "Образ собран"
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
          curl -sf http://todo-app:5000/health | grep -q ok
          curl -sf http://todo-app:5000/ | grep -q "Список задач"
          echo "Flask-приложение на master отвечает"
        '''
      }
    }
  }
}
