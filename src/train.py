import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
import pickle

df = pd.read_csv('data/Rampur.csv')
df=df.dropna()
x=df[['Tmax','Tmin','Rainfall']]
y=df['Discharge']

x_train,x_test,y_train,y_test = train_test_split(x,y,test_size=0.3,random_state=42)

model = RandomForestRegressor()
model.fit(x_train,y_train)
model.predict(x_test)

with open('models/model.pkl', 'wb') as file:
    pickle.dump(model, file)


