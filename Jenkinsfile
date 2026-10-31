pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
    }
    triggers { pollSCM('H/5 * * * *') }
    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: false,
                     description: 'Deploy to the configured Ubuntu service')
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps {
                sh 'python3 -m venv .venv'
                sh '.venv/bin/python -m pip install -r requirements-dev.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'mkdir -p test-results'
                sh '.venv/bin/python -m pytest tests/ -v --junitxml=test-results/pytest.xml'
            }
            post {
                always { junit 'test-results/pytest.xml' }
            }
        }
        stage('Package') {
            steps {
                sh 'mkdir -p dist && tar --exclude=__pycache__ -czf dist/lab1-${BUILD_NUMBER}.tar.gz app scripts docs/devops-lab1.service'
                archiveArtifacts artifacts: 'dist/*.tar.gz', fingerprint: true
            }
        }
        stage('Deploy') {
            when { expression { params.DEPLOY } }
            steps { sh 'sudo -n /usr/local/sbin/deploy-lab1 "$WORKSPACE"' }
        }
    }
    post {
        success { echo 'Lab 1 build passed' }
        failure { echo 'Lab 1 build failed; check the stage output' }
    }
}
