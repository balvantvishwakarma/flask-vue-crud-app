#!/bin/bash
APP_DIR="/home/ec2-user/flask-vue-crud"
REPO_URL="https://github.com/balvantvishwakarma/flask-vue-crud-app.git"

echo "=== Starting Deployment via AWS SSM ==="
if [ ! -d "$APP_DIR" ]; then
    echo "Folder nahi mila. Fresh clone kar rahe hain..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR" || exit 1
else
    echo "Folder pehle se maujood hai. Sirf naye changes pull kar rahe hain..."
    cd "$APP_DIR" || exit 1
    git reset --hard HEAD
    git pull origin main
fi
echo "Rebuilding and restarting Docker containers..."
sudo docker compose down
sudo docker compose up -d --build
sudo docker system prune -f
echo "=== Deployment Successful ==="
