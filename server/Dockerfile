FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install "werkzeug<3.0.0"
COPY . .
EXPOSE 5001
CMD ["flask", "run", "--host=0.0.0.0", "--port=5001", "--debug"]
