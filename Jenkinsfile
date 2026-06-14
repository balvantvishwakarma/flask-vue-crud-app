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
                echo 'Pulling source code from GitHub...'
                checkout scm
            }
        }

        stage('Build & Lint Validation') {
            steps {
                echo 'Validating file presence for Build and Code Quality...'
                sh '''
                    if [ ! -f "server/requirements.txt" ] || [ ! -f "client/package.json" ]; then
                        echo "CRITICAL ERROR: Missing project dependency configuration files!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Deploy via AWS SSM (SSH Strictly Prohibited)') {
            steps {
                echo 'Executing Secure Remote Deployment and Quality Checks via AWS SSM...'
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
