pipeline {
    agent any
    environment {
        AWS_REGION    = 'us-east-1'
        INSTANCE_ID   = 'i-039aabe98ae5694a7'
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
                echo 'Running Python Linting via flake8...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install flake8
                    cd server && flake8 .
                '''
            }
        }

        stage('Deploy via AWS SSM') {
            steps {
                echo 'Dispatching deployment and waiting for result...'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials-id',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                        // 1. Command bhejo, Command ID lo
                        def cmdId = sh(
                            script: """
                                aws ssm send-command \
                                    --document-name "AWS-RunShellScript" \
                                    --instance-ids "${INSTANCE_ID}" \
                                    --parameters 'commands=["bash /home/ec2-user/flask-vue-crud/deploy.sh"]' \
                                    --timeout-seconds 300 \
                                    --region ${AWS_REGION} \
                                    --query 'Command.CommandId' \
                                    --output text
                            """,
                            returnStdout: true
                        ).trim()

                        echo "SSM Command ID: ${cmdId}"

                        // 2. Jab tak complete na ho, wait karo (max 5 min)
                        sh """
                            aws ssm wait command-executed \
                                --command-id "${cmdId}" \
                                --instance-id "${INSTANCE_ID}" \
                                --region ${AWS_REGION}
                        """

                        // 3. Exit code aur output check karo
                        def result = sh(
                            script: """
                                aws ssm get-command-invocation \
                                    --command-id "${cmdId}" \
                                    --instance-id "${INSTANCE_ID}" \
                                    --region ${AWS_REGION} \
                                    --output json
                            """,
                            returnStdout: true
                        ).trim()

                        def json       = readJSON text: result
                        def exitCode   = json.ResponseCode
                        def stdout     = json.StandardOutputContent
                        def stderr     = json.StandardErrorContent

                        echo "=== Deploy Script Output ==="
                        echo stdout

                        if (exitCode != 0) {
                            echo "=== STDERR ==="
                            echo stderr
                            error("Deploy FAILED! deploy.sh exit code: ${exitCode}")
                        }

                        echo "Deployment successful (exit code: 0)"
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline FAILED — check SSM output above for details."
        }
        success {
            echo "All stages passed. App is live!"
        }
    }
}
