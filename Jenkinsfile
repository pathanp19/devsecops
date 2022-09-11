pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }


      stage('Unit Tests') {
          steps {
            sh "mvn test"
          }
          post {
            always {
              junit 'target/surefire-reports/*.xml'
              jacoco execPattern: 'target/jacoco.exec'
            }
          }
      }
      stage('Docker build & push') {
         steps {
             docker.withRegistry(https://hub.docker.com/, docker-hub) {
                 sh 'printenv'
                 sh 'docker build -t pathanp19/devsecops-numeric-app:""$GIT_COMMIT"" .'
                 sh 'docker push pathanp19/devsecops-numeric-app:""$GIT_COMMIT""'
                 }
             }
         }
      }
}