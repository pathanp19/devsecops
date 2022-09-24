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
    }
    stage('Mutation Tests') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
    }
    stage('Sonarqube SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn sonar:sonar -Dsonar.projectKey=numeric -Dsonar.host.url=http://devsecops-demokhan.eastus.cloudapp.azure.com:9000"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }

    stage('Vulnerability Scan - Docker') {
      steps {
        parallel(
            "Dependency Scan": {
                sh "mvn dependency-check:check"
            },
            "Trivy Scan":{
                sh "bash trivy-docker-image-scan.sh"
            },
            "OPA Conftest":{
                sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
            }
        )
      } 
    }
    
    stage('Docker build & push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'sudo docker build -t pathanp19/devsecops-numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push pathanp19/devsecops-numeric-app:""$GIT_COMMIT""'
        }
      }
    }
    
    stage ('vulnerability scan - kubernetes') {
      steps {
            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
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
   
  post { 
        always { 
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        }
    }

}