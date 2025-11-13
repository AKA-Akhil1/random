from flask import Flask, request, jsonify, render_template
import pickle
import numpy as np
import os

app = Flask(__name__, template_folder='../templates')

try:
    with open('models/model.pkl', 'rb') as f:
        model = pickle.load(f)
    print("✅ Model loaded successfully")
except FileNotFoundError:
    print("❌ Model file not found! Run train.py first")
    model = None
except Exception as e:
    print(f"❌ Error loading model: {e}")
    model = None

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'success': False, 'error': 'Model not loaded. Run training first.'}), 500
        
    try:
        # Get JSON data from request
        data = request.get_json()
        
        # Extract features
        tmax = float(data['Tmax'])
        tmin = float(data['Tmin'])
        rainfall = float(data['Rainfall'])
        
        # Make prediction
        features = np.array([[tmax, tmin, rainfall]])
        prediction = model.predict(features)[0]
        
        return jsonify({
            'success': True,
            'prediction': round(float(prediction), 2),
            'input': {'Tmax': tmax, 'Tmin': tmin, 'Rainfall': rainfall}
        })
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 400

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)