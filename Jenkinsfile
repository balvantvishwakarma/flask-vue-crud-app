pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Confirm kar lena aapka EC2 isi region me hai
        INSTANCE_ID = 'i-039aabe98ae5694a7' // <-- YAHA APNE ASLI EC2 KI INSTANCE ID DAALNA MAT BHOOLNA
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
                echo 'Executing Secure Remote Deployment via AWS SSM...'
                
                // CloudBees AWS Credentials Plugin ka sahi format
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials-id', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
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
