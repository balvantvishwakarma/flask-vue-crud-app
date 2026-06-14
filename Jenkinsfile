pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' 
        INSTANCE_ID = 'i-039aabe98ae5694a7' // Aapka confirm AWS Instance ID
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling latest source code from GitHub...'
                checkout scm
            }
        }

        stage('Build & Asset Verification') {
            steps {
                echo 'Validating Frontend & Backend configurations...'
                script {
                    if (!fileExists('server/requirements.txt') || !fileExists('client/package.json')) {
                        error("CRITICAL: Structural configuration files are missing!")
                    }
                }
            }
        }

        stage('Lint (Code Quality)') {
            steps {
                echo 'Running Python Linting checks via flake8...'
                // Jenkins container ke andar ab python3 aur pip natively chalega
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install flake8
                    cd server && flake8 .
                '''
            }
        }

        stage('Deploy via AWS SSM (No SSH)') {
            steps {
                echo 'Dispatching secure deployment command via AWS CLI...'
                
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials-id', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // Ab Jenkins ke andar 'aws' CLI natively available hai!
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
