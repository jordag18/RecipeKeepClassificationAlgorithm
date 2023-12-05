import joblib
import mysql.connector
import json
import sys
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import accuracy_score
import pickle
import jsonpickle
from ast import literal_eval
from flask import Flask, request, jsonify
import RecipeDatabase


app = Flask(__name__)
# Sample dataset of recipes and their ingredients
vectorizer = pickle.load(open('vectorizer.pickle', 'rb'))
mlb = pickle.load(open('mlb.pickle', 'rb'))
clf = pickle.load(open('classification.model', 'rb'))


@app.route('/predict', methods=['POST'])
def predict():
    data = request.data
    print(data)
    converted_data = literal_eval(data.decode('utf8'))
    print(type(converted_data['features']), flush=True)
    prediction = clf.predict(vectorizer.transform(converted_data['features']))
    prediction_label = mlb.inverse_transform(prediction)
    print(list(prediction_label[0]))
    return jsonify({'prediction': list(prediction_label[0])})


@app.route('/pull', methods=['GET'])
def test():
    data = RecipeDatabase.pullRecipeFromDatabase()
    return jsonify(data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

