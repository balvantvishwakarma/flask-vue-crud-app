#!/bin/bash
# deploy.sh

APP_DIR="/home/ec2-user/flask-vue-crud"
REPO_URL="https://github.com/balvantvishwakarma/flask-vue-crud-app.git"

echo "=== Starting Deployment via AWS SSM ==="

# 1. Agar folder nahi hai, to clone karo
if [ ! -d "$APP_DIR" ]; then
    echo "Folder nahi mila. Fresh clone kar rahe hain..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR" || exit 1
else
    # 2. Agar folder pehle se hai, to andar jao aur changes pull karo
    echo "Folder pehle se maujood hai. Sirf naye changes pull kar rahe hain..."
    cd "$APP_DIR" || exit 1
    
    # Kisi bhi local temporary conflict ko saaf karne ke liye reset aur pull
    git reset --hard HEAD
    git pull origin main
fi

# 3. Clean and Restart Containers
echo "Rebuilding and restarting Docker containers..."
sudo docker compose down
sudo docker compose up -d --build

# 4. Unused space saaf karne ke liye
sudo docker system prune -f

echo "=== Deployment Successful ==="
