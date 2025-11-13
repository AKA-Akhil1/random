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

# Copy tests and data into container
COPY tests/ ./tests/
COPY data/ ./data/

# Create a test script that uses the model with sample inputs and calculates R2 score
RUN echo 'import pickle\n\
import numpy as np\n\
from sklearn.model_selection import train_test_split\n\
import pandas as pd\n\
from sklearn.metrics import r2_score\n\
\n\
# Load and prepare data for R2 calculation\n\
df = pd.read_csv("data/Rampur.csv")\n\
df = df.dropna()\n\
x = df[["Tmax", "Tmin", "Rainfall"]]\n\
y = df["Discharge"]\n\
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.35, random_state=42)\n\
\n\
# Load the trained model\n\
with open("models/model.pkl", "rb") as f:\n\
    model = pickle.load(f)\n\
\n\
# Calculate R2 score\n\
y_pred = model.predict(x_test)\n\
r2 = r2_score(y_test, y_pred) * 100\n\
\n\
# Sample test inputs\n\
test_cases = [[35.2, 18.5, 12.3], [28.7, 15.1, 45.6], [32.1, 20.8, 8.9], [25.4, 12.3, 67.2]]\n\
\n\
print("=== Water Discharge Prediction Results ===")\n\
print(f"Model R2 Score: {r2:.2f}%")\n\
print()\n\
\n\
for i, inputs in enumerate(test_cases, 1):\n\
    tmax, tmin, rainfall = inputs\n\
    prediction = model.predict([inputs])[0]\n\
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