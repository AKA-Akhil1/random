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

# Create a test script that uses the model with sample inputs
RUN echo 'import pickle\n\
import numpy as np\n\
\n\
# Load the trained model\n\
with open("models/model.pkl", "rb") as f:\n\
    model = pickle.load(f)\n\
\n\
# Sample test inputs (Tmax, Tmin, Rainfall)\n\
test_cases = [\n\
    [35.2, 18.5, 12.3],\n\
    [28.7, 15.1, 45.6],\n\
    [32.1, 20.8, 8.9],\n\
    [25.4, 12.3, 67.2]\n\
]\n\
\n\
print("=== Water Discharge Prediction Test ===")\n\
print("Model loaded successfully!")\n\
print()\n\
\n\
for i, inputs in enumerate(test_cases, 1):\n\
    tmax, tmin, rainfall = inputs\n\
    features = np.array([inputs])\n\
    prediction = model.predict(features)[0]\n\
    \n\
    print(f"Test Case {i}:")\n\
    print(f"  Inputs: Tmax={tmax}°C, Tmin={tmin}°C, Rainfall={rainfall}mm")\n\
    print(f"  Predicted Discharge: {prediction:.2f} units")\n\
    print()\n\
\n\
print("✅ All predictions completed successfully!")' > test_model.py

# Command to run the test script when container starts
CMD ["python", "test_model.py"]

# Build test image: docker build -f Dockerfile.test -t water-predictor-test .
# Run test container: docker run water-predictor-test