pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' 
        INSTANCE_ID = 'i-039aabe98ae5694a7' // Aapka sahi Instance ID automatic lag gaya hai
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
                echo 'Executing Secure Remote Deployment via AWS CLI Docker Container...'
                
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials-id', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // Local AWS CLI ki jagah official amazon/aws-cli container use kar rahe hain
                    sh """
                        docker run --rm \
                            -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                            -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                            -e AWS_DEFAULT_REGION=${AWS_REGION} \
                            amazon/aws-cli \
                            ssm send-command \
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
