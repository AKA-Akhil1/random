# Use Python 3.10 slim image as base (lightweight version)
FROM python:3.10-slim

# Set working directory inside container to /app
WORKDIR /app

# Copy requirements.txt first (for Docker layer caching optimization)
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code into container
COPY src/ ./src/

# Copy trained model into container
COPY models/ ./models/

# Copy HTML templates into container
COPY templates/ ./templates/

# Expose port 5000 (tells Docker this container listens on port 5000)
EXPOSE 5000

# Set environment variable to tell Flask to run on all interfaces
ENV FLASK_RUN_HOST=0.0.0.0

# Command to run when container starts (starts the Flask app)
CMD ["python", "src/app.py"]

## Build Docker image (. means current directory)
#docker build -t water-predictor .

# Run container and map port 5000 from container to host port 5000
#docker run -p 5000:5000 water-predictor