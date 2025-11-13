from flask import Flask, request, jsonify, render_template
import pickle
import numpy as np

app = Flask(__name__, template_folder='../templates')

# Load model
with open('models/model.pkl', 'rb') as f:
    model = pickle.load(f)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    features = np.array([[data['Tmax'], data['Tmin'], data['Rainfall']]])
    prediction = model.predict(features)[0]
    return jsonify({'prediction': float(prediction)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)