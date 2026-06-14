https://github.com/user-attachments/assets/39b79e4f-2624-4717-9f48-46fbdf2799fa

# 🏗️ Enterprise-Grade Production CI/CD Pipeline for Multi-Service Architecture

This project demonstrates a production-ready, highly secure **Continuous Integration and Continuous Deployment (CI/CD)** ecosystem engineered on the principles of **Zero-Trust Network Security** and **Immutable Infrastructure-as-Code (IaC)**. 

The primary architectural paradigm rules that the production server must completely eliminate external administrative vector entry; therefore, **Inbound Port 22 (SSH) is strictly prohibited and removed from the AWS Security Group.** All deployment orchestration, continuous code analysis, and infrastructure sync states are securely tunneled using the cloud-native **AWS Systems Manager (SSM) API Core**.
<img width="752" height="769" alt="basesolve drawio" src="https://github.com/user-attachments/assets/2d6a7fd3-dc30-4c6b-a0dc-7aa3499b01e2" />

---

## 📝 Complete Step-by-Step Engineering Process

### 🔐 Step 1: Cloud Access Identity & Privilege Authorization (IAM)
To orchestrate global infrastructure resources under least-privilege principles, the IAM boundary layer was engineered as follows:
* **Programmatic CI/CD Bot Account:** Provisioned a dedicated external deployment IAM entity with minimal execution allowances. Generated secure API bindings (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) to manage remote handshakes.
* **AWS SSM Trust Policy Matrix:** Created a targeted IAM Execution Role named `EC2-SSM-Role`, specifying `ec2.amazonaws.com` as the primary trusted computing service principal.
* **Granular Policy Entitlements:** Affixed the managed policy `AmazonSSMManagedInstanceCore` straight onto the operational role profile. This enables native, encrypted bidirectional state synchronizations without opening corporate routing boundaries to edge scans.

---

### 🖥️ Step 2: Guarded Production Host Provisioning (Target Machine)
The live deployment compute nodes are configured to maintain a highly restricted footprint:
* **Operating System Base:** Provisioned the instance using a minimal architecture footprint native to **Amazon Linux 2023** secure kernel blueprints.
* **IAM Instance Profile Attestation:** Bound the immutable runtime execution blueprint (`EC2-SSM-Role`) directly into the active hardware launching layer as an active Instance Profile.
* **Firewall Hardening (Edge SGs):** Configured network security boundaries where **Port 22 (SSH) was entirely discarded from the ingress rules.** Only standard reverse-proxy listener binds were opened to global routing traffic: Port `5173` (Vue.js Production Client Node) and Port `5001` (Flask REST API Framework Node).

---

### 🛠️ Step 3: Zero-Edge Remote Host Provisioning via SSM Sessions
To keep the node isolated, software layers were installed natively via session protocols instead of raw open terminal setups:
* **SSM Secure Session Interfacing:** Connected to the host natively via the AWS Systems Manager **Session Manager** browser API conduit, avoiding keys exposure on local client hosts.
* **Container Orchestration Environment Deployed:** Installed the container architecture engines directly onto the target base OS layer:
  ```bash
  sudo dnf update -y
  sudo dnf install docker -y
  sudo systemctl enable --now docker


  📦 Step 4: Containerization and Multi-Service Composition Design
To prevent system dependency drift, the independent logic blocks were split completely into atomic images:

Backend Component Layer (server/Dockerfile): Engineered a clean multi-stage runtime workspace setup built on top of a lightweight python:3.11-slim framework image. Confirmed ports to listen and bind cleanly on 5001.

Frontend Component Architecture (client/Dockerfile): Designed a separate asset compiler tracking optimal asset management workflows, emitting native high-performance optimized web bundles.

Distributed Services Orchestration (docker-compose.yml): Formulated a core container mesh engine script ensuring total localized sub-network space mapping, runtime environment data binding, and autonomous service recovery loops (restart: unless-stopped).

🎡 Step 5: Isolated Custom Jenkins CI Engine (CI/CD Master Machine)
The compilation node was engineered inside a custom immutable environment running on an entirely separate network block to ensure high build separation boundaries:

Jenkins Master Provisioning: Launched the CI cluster stack using containerized long-term service (LTS) architectures.

Volume Persistence Guard: Bound a direct system path network volume directory cluster (jenkins_data) onto /var/jenkins_home to ensure plugin states persist across machine crashes.

Custom Built Toolchain & Layer Hardening: The basic native Jenkins image lacks default operational software (aws-cli, python3, pip, docker). To clear this constraint, a custom multi-stage Dockerfile was designed, safe-routing host process run loops (/var/run/docker.sock) into root execution context mappings right inside the customized master container.

🔐 Step 6: Vault Management & Security Controls
Configured strict token access references directly inside the encrypted configurations console:

Credentials Framework Hook: Embedded the native enterprise CloudBees AWS Credentials Binding architecture onto the execution model.

Data Parameter Tokenization: Safely passed the access credentials directly into a secured token key mapping referenced as aws-credentials-id. This abstract configuration prevents raw hardcoding practices in repository tracking scripts.

📜 Step 7: Deterministic Declarative Pipelines Scripting (Jenkinsfile)
Developed a highly resilient, automated build script at the base of the source tree tracking three vital automation actions:

Source Tracking (Checkout Stage): Safely checks out the target code repo commits straight from the active origin source repository tree.

Static Analysis Checks (Linting Stage): Creates an isolated runtime environment with Python venv, configures fresh rules parsing extensions, and evaluates scripts using flake8 configurations. Code compliance is enforced strictly; any low-quality standard alerts will drop the rollout stage instantly.

SSM Deployment Stage: The custom compiled internal Jenkins aws-cli tool loads the dynamic access key tokens securely, constructs the request payload dictionary structure, and calls the global Systems Manager endpoint directly.

🎛️ Step 8: Non-Interactive Automation Deployment Logic (deploy.sh)
When the AWS SSM Agent on the production machine triggers the execution lifecycle hook, it fires the deployment code script dynamically:

Safely changes target workspaces onto path locations /home/ec2-user/flask-vue-crud.

Purges transient tracking variations and hard resets branch pointers: git reset --hard HEAD and git pull origin main.

Zero-Downtime Application Reloads: Gracefully drops older structural contexts and triggers optimized rebuild patterns inside active compose states (docker compose up -d --build). Orphan structures or hanging context layers are systematically deleted via routine maintenance wrappers (docker system prune -f).

⚡ Step 9: Git Web-Event Dispatch Webhook Integration (The Full Loop)
The dynamic continuous release lifecycle mechanism was finalized by setting up real-time web-trigger bridges:

GitHub Repository Ingress Webhook: Configured a native notification hook mapped directly to the automated Jenkins ingestion address:
http://3.235.186.7:8080/github-webhook/

Network Integration Settings: Specified content transmission formatting properties onto standardized JSON parameters (application/json). Explicitly switched off global intermediate TLS verification checks to bypass network routing restrictions on developmental plain-text HTTP protocol edge endpoints.

📈 Key Deliverables & Production Outcomes
🛡️ 100% SSH-Less Security Layer: Achieved absolute infrastructure management boundary security with no visibility signatures exposed to port-based scanning bots.

🛑 Deterministic Delivery Rules: Enforced clean coding standards where dirty formatting blocks deployment pipelines at compilation stages.

⚡ True Continuous Integration/Deployment: Optimized production release frequencies, scaling the entire code-commit-to-live-production cycle to under 60 seconds in an event-driven loop.
