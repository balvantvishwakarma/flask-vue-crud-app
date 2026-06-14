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
                echo 'Validating file presence for Build and Code Quality...'
                sh '''
                    if [ ! -f "server/requirements.txt" ] || [ ! -f "client/package.json" ]; then
                        echo "CRITICAL ERROR: Missing project dependency configuration files!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Deploy via AWS SSM') {
            steps {
                echo 'Executing Remote Deployment via Native Jenkins AWS API Step...'
                
                // Hum direct plugin framework inject kar rahe hain, isme backend se HTTP API call jayegi
                withAWS(credentials: 'aws-credentials-id', region: "${AWS_REGION}") {
                    // Kisi CLI ya Docker command ki zaroorat nahi padegi
                    awsSSMSendCommand(
                        instanceIds: ["${INSTANCE_ID}"],
                        documentName: 'AWS-RunShellScript',
                        parameters: [
                            commands: ["bash /home/ec2-user/flask-vue-crud/deploy.sh"]
                        ]
                    )
                }
            }
        }
    }
}
