import pickle
from sklearn.model_selection import train_test_split
import pandas as pd
import sklearn.metrics as r2_score

df = pd.read_csv('data/Rampur.csv')
df = df.dropna()
x = df[['Tmax', 'Tmin', 'Rainfall']]
y = df['Discharge']
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.35, random_state=42)

with open('models/model.pkl', 'rb') as file:
    model = pickle.load(file)

y_pred = model.predict(x_test)

r2 = r2_score.r2_score(y_test,y_pred)*100
print(r2)

def test_model_performance():
    if r2>70:
        print("Test Passed")
    assert r2 > 70, "Model performance is below acceptable threshold."

test_model_performance()