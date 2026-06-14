# client/Dockerfile

FROM node:20-slim

WORKDIR /app

# Dependencies install karne ke liye
COPY package*.json ./
RUN npm install

# Poora client code copy karne ke liye
COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
