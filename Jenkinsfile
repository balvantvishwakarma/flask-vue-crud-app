pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        INSTANCE_ID = 'i-039aabe98ae5694a7'
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
                    script {
                        // Step 1:
                        def commandId = sh(
                            script: """
                                aws ssm send-command \
                                    --document-name "AWS-RunShellScript" \
                                    --instance-ids "${INSTANCE_ID}" \
                                    --parameters 'commands=["bash /home/ssm-user/flask-vue-crud/deploy.sh"]' \
                                    --timeout-seconds 100 \
                                    --region ${AWS_REGION} \
                                    --query Command.CommandId \
                                    --output text
                            """,
                            returnStdout: true
                        ).trim()

                        echo "SSM Command ID: ${commandId}"

                        // Step 2: 
                        echo 'Waiting for SSM command to complete...'
                        sh """
                            aws ssm wait command-executed \
                                --command-id ${commandId} \
                                --instance-id ${INSTANCE_ID} \
                                --region ${AWS_REGION}
                        """

                        // Step 3: 
                        def ssmOutput = sh(
                            script: """
                                aws ssm get-command-invocation \
                                    --command-id ${commandId} \
                                    --instance-id ${INSTANCE_ID} \
                                    --region ${AWS_REGION} \
                                    --output text \
                                    --query 'StandardOutputContent'
                            """,
                            returnStdout: true
                        ).trim()

                        def ssmError = sh(
                            script: """
                                aws ssm get-command-invocation \
                                    --command-id ${commandId} \
                                    --instance-id ${INSTANCE_ID} \
                                    --region ${AWS_REGION} \
                                    --output text \
                                    --query 'StandardErrorContent'
                            """,
                            returnStdout: true
                        ).trim()

                        def ssmStatus = sh(
                            script: """
                                aws ssm get-command-invocation \
                                    --command-id ${commandId} \
                                    --instance-id ${INSTANCE_ID} \
                                    --region ${AWS_REGION} \
                                    --output text \
                                    --query 'Status'
                            """,
                            returnStdout: true
                        ).trim()

                        // Step 4: 
                        echo "========== SSM Command Status: ${ssmStatus} =========="
                        echo "========== SSM STDOUT =========="
                        echo ssmOutput
                        echo "========== SSM STDERR =========="
                        echo ssmError

                        // Step 5: 
                        if (ssmStatus != "Success") {
                            error("SSM Deployment FAILED with status: ${ssmStatus}. Check SSM logs above for details.")
                        }

                        if (ssmError?.trim()) {
                            echo "WARNING: SSM command completed but stderr has content. Review logs above."
                        }

                        echo 'Deployment completed successfully!'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline SUCCESS: Deployment completed!'
        }
        failure {
            echo 'Pipeline FAILED: Check SSM logs above for deployment errors.'
        }
        always {
            echo 'Pipeline finished. Cleaning up workspace...'
            cleanWs()
        }
    }
}
