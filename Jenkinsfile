pipeline {
    agent any

    environment {
        AWS_CRED = credentials('aws-credentials-id') 
        AWS_REGION = 'us-east-1' 
        INSTANCE_ID = 'i-039aabe98ae5694a7' 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Validating Frontend Build using Docker Node Image...'
                // Local npm ki jagah hum temporary node container me npm install check kar rahe hain
                sh 'docker run --rm -v $(pwd)/client:/app -w /app node:20-slim npm install'
            }
        }

        stage('Lint') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install flake8
                    cd server && flake8 .
                '''
            }
        }

        stage('Docker Build Test') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Deploy via AWS SSM') {
            steps {
                withEnv([
                    "AWS_ACCESS_KEY_ID=${AWS_CRED_USR}", 
                    "AWS_SECRET_ACCESS_KEY=${AWS_CRED_PSW}",
                    "AWS_DEFAULT_REGION=${AWS_REGION}"
                ]) {
                    sh """
                        aws ssm send-command \
                            --document-name "AWS-RunShellScript" \
                            --instance-ids "${INSTANCE_ID}" \
                            --parameters 'commands=["bash /home/ec2-user/flask-vue-crud/deploy.sh"]' \
                            --region ${AWS_REGION}
                    """
                }
            }
        }
    }
}
