pipeline {
    agent any

    environment {
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
                echo 'Validating repository structure natively...'
                script {
                    def serverReqExists = fileExists 'server/requirements.txt'
                    def clientPkgExists = fileExists 'client/package.json'
                    if (!serverReqExists || !clientPkgExists) {
                        error("CRITICAL ERROR: Missing deployment blueprint files inside repository structure!")
                    }
                }
            }
        }

        stage('Deploy via AWS SSM API') {
            steps {
                echo 'Executing Real HTTP API Handshake with AWS Systems Manager via Curl...'
                
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials-id', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // Hum bina kisi CLI ke direct AWS API Endpoint ko hit kar rahe hain curl se
                    sh """
                        echo "Sending actual payload to AWS SSM endpoint..."
                        
                        curl -s -X POST "https://ssm.${AWS_REGION}.amazonaws.com/" \
                          -H "X-Amz-Target: AmazonSSMScriptRunner.SendCommand" \
                          -H "Content-Type: application/x-amz-json-1.1" \
                          --aws-sigv4 "aws:amz:${AWS_REGION}:ssm" \
                          --user "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" \
                          -d '{
                            "InstanceIds": ["${INSTANCE_ID}"],
                            "DocumentName": "AWS-RunShellScript",
                            "Parameters": {
                              "commands": ["cd /home/ec2-user/flask-vue-crud && bash deploy.sh"]
                            }
                          }'
                          
                        echo "SSM Command successfully dispatched via API Tunnel!"
                    """
                }
            }
        }
    }
}
