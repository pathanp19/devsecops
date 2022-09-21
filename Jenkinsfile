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
            sh "mvn -version"
            sh "mvn test"
          }
          post {
            always {
              junit 'target/surefire-reports/*.xml'
              jacoco execPattern: 'target/jacoco.exec'
            }
          }
      }
      stage('Mutation Tests') {
          steps {
            sh "mvn org.pitest:pitest-maven:mutationCoverage"
          }
          post {
            always {
              pitmutation mutationStatsFile: '**/target/pit-reports/*/mutations.xml'
            }
          }
      }
      stage('Sonarqube SAST') {
              steps {
                  withSonarQubeEnv('SonarQube') {
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=devsecops-numeric -Dsonar.host.url=http://devsecops-demokhan.eastus.cloudapp.azure.com:9000 -Dsonar.login=sqp_83f119205eb297688886b13dcc2fea055c54a20e -Dsonar.login=admin -Dsonar.password=admin123"
                  }
                  timeout(time: 2, unit: 'MINUTES') {
                    script {
                      waitForQualityGate abortPipeline: true
                    }
                  }
          }
      }
      stage('Docker build & push') {
         steps {
             withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
                 sh 'printenv'
                 sh 'docker build -t pathanp19/devsecops-numeric-app:""$GIT_COMMIT"" .'
                 sh 'docker push pathanp19/devsecops-numeric-app:""$GIT_COMMIT""'
                 }
             }
         }

      stage('kubernetes deploy - dev') {
              steps {
                  withKubeConfig([credentialsId: 'kubeconfig']) {
                  sh "sed -i 's#replace#pathanp19/devsecops-numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                  sh "kubectl apply -f k8s_deployment_service.yaml"
                  }
              }
      }
  }
}