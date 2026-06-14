🏗️ Architectural Overview & Design Pattern
The architecture is built on the foundation of Zero-Trust Network Security and Immutable Infrastructure-as-Code (IaC) principles. The core design paradigm dictates that the production environment must completely eliminate administrative edge exposure; hence, Inbound Port 22 (SSH) is strictly prohibited and decoupled from the security group configurations. Management payload execution, artifact synchronizations, and application state rollouts are channeled through an authenticated proxy layer using AWS Systems Manager (SSM) API gateways.

📝 Comprehensive Step-by-Step Engineering Pipeline
🔐 Phase 1: Cloud Access Identity & Privilege Authorization (IAM)
To orchestrate infrastructure resources securely, granular Least-Privilege access bounds were engineered at the AWS Identity and Access Management (IAM) level:

Programmatic CI/CD Bot Deployment User 🔑: Formulated a dedicated programmatic IAM User entity to authenticate external Jenkins webhook callbacks. Generated an explicit encrypted bundle containing the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.

AWS SSM Trust Policy Brokerage 🎖️: Provisioned an AWS IAM Service Execution Role named EC2-SSM-Role, designating Amazon Elastic Compute Cloud (ec2.amazonaws.com) as the trusted identity principal.

Granular Policy Entitlements 📋: Affixed the managed AWS policy AmazonSSMManagedInstanceCore directly to the role structure. This establishes a bidirectional state handshake between the host's operating system environment and the cloud's secure telemetry endpoints without relying on edge routing loops.

🖥️ Phase 2: Guarded Production Host Provisioning (Target Infrastructure)
The production host parameters were designed to survive automated configuration validation patterns safely:

Operating System Isolation 🚀: Spawned a cluster instance backed by the official Amazon Linux 2023 minimal AMI framework, native to modern security kernel structures.

IAM Instance Profile Handshake 📎: Bound the immutable execution entity EC2-SSM-Role as the instance profile during runtime initiation phases.

Edge Port Hardening (Firewall Config) 🔒: Structured an isolated AWS Security Group mapping. Port 22 was intentionally omitted from the firewall lifecycle. Inbound routes were limited exclusively to public container bindings: Port 5173 (Vue.js Production Single-Page Architecture) and Port 5001 (Flask RESTful API Microservice).

🛠️ Phase 3: Zero-Edge Remote Host Bootstrapping via SSM Telemetry
Instead of interactive SSH terminal loops, remote configuration provisioning was managed inside secure AWS systems sessions:

SSM Secure Tunnel Interfacing 🔌: Leveraged the AWS Systems Manager Session Manager browser API layer, establishing an ephemeral interactive sh/bash bridge using standard AWS Key-Management (KMS) layers.

Container Orchestration Engine Installation 🐋: Handled core system packaging and deployed the isolated runtime runtimes for local multi-container services:

Bash
sudo dnf update -y
sudo dnf install docker -y
sudo systemctl enable --now docker

📦 Phase 4: Containerization and Multi-Service Orchestration Design
The decoupled components were isolated into microservices to enforce microservices clean-start principles:

Backend Component Framework (server/Dockerfile) 🐍: Engineered a deterministic multi-stage runtime build utilizing lightweight python:3.11-slim image footprints. Configured environment interfaces to map REST requests cleanly across port 5001.

Frontend Component Architecture (client/Dockerfile) 🌐: Structured an optimized multi-tier compilation utilizing Node.js for state building, exporting high-performance assets served directly via integrated container proxies.

Distributed Services Orchestration (docker-compose.yml) 🎼: Formulated an overall declarative composition map ensuring automatic host network separation, robust runtime environment injection (.env configurations), and clean recovery state triggers (restart: unless-stopped).

🎡 Phase 5: Self-Contained, Isolated Jenkins CI Engine (CI Master Machine)
The pipeline engine was designed inside an immutable container architecture hosted on an entirely separate workspace boundary node to maximize staging isolation:

Orchestration Container Setup 📥: Launched the automation server using a containerized long-term service (LTS) base setup inside a specialized machine node block.

State Preservation via Persistent Volumes 💾: Mapped a system host path directory storage cluster volume (jenkins_data) directly onto /var/jenkins_home to ensure configuration data persistence across restarts.

Custom Toolchain Synthesis & Image Layer Hardening 🛠️: The vanilla base Jenkins image lacked foundational platform tools (aws-cli, python3, pip, docker). To correct this, a custom multi-stage Dockerfile was engineered, mapping host sockets safely through root-group execution permissions (/var/run/docker.sock) directly into the specialized image core layer.

🔐 Phase 6: Vault Storage & External Pipeline Authentication Configuration
Secured sensitive parameter bindings within the localized Jenkins credentials architecture:

Identity Mapping Integration 🤝: Deployed the enterprise CloudBees AWS Credentials Binding architecture plugin stack directly into the configuration runtime engine.

Secret Parameter Tokenization 🗝️: Injected the credentials bundle safely inside an encrypted global ID mapping wrapper labeled aws-credentials-id. This abstract reference ensures keys are never exposed in plaintext files.

📜 Phase 7: Deterministic Declarative Pipelines Blueprint (Jenkinsfile)
Developed a strict declarative automation script within the root of the source control tree:

Checkout Stage 🔄: Extracts code from the designated remote source control platform branch natively.

Static Analysis Code Quality Validation (Linting) 🧪: Initiates an isolated, non-polluting virtual runtime boundary layer using Python venv, fetches modern formatting dependencies, and executes flake8 directly against structural pattern rules defined in .flake8. The script enforces explicit compliance and deliberately drops the execution phase immediately upon code quality alerts.

AWS SSM API Deployment Stage 📡: The internally compiled Jenkins aws-cli tool reads token variables securely, builds a programmatic parameter payload block, and triggers the cloud-native Systems Manager endpoint directly.

🎛️ Phase 8: Non-Interactive Automation Deployment Logic (deploy.sh)
When the remote AWS Systems Manager engine receives the call context, it uses local machine boundaries to trigger the deployment shell pipeline:

Changes to directory spaces occur securely inside localized deployment folders.

Erases local configurations and enforces git synchronization parameters: git reset --hard HEAD and git pull origin main.

Zero-Downtime State Rollouts: Stops old containers safely and immediately triggers high-performance compilations inside docker-compose states (docker compose up -d --build). Remnants or hanging docker dangling tags are removed by clean-up garbage routines (docker system prune -f).

⚡ Phase 9: GitHub Webhook Web-Event Dispatch Integration (Full CI/CD Loop)
The continuous rollout mechanism was completed by implementing real-time event bridges:

GitHub Webhook Routing 🌐: Formulated an direct notification hook bound directly onto the Jenkins programmatic context receptor endpoint:
http://3.235.186.7:8080/github-webhook/

Network Constraint Configurations ⚙️: Mapped content encoding schemes directly onto strict JSON formatting parameters (application/json). Deactivated intermediate TLS checks specifically to bypass regional development protocol restrictions on public routing endpoints.

📈 Key Deliverables & Engineering Outcomes
100% SSH-Less Infrastructure: Ensured robust infrastructure administration compliance with zero visibility on legacy port-based scanning targets.

Bulletproof Deterministic Linting: Enforced enterprise code structure where dirty formatting explicitly blocks delivery lifecycles.

Fully Automated Pipeline Execution: Reduced developer commit-to-production cycles to under 60 seconds under an end-to-end event-driven workflow.
