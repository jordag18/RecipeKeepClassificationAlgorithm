import mysql.connector
import json
import pandas as pd
import pickle

from flask import jsonify
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import accuracy_score


class Object:
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=8)


# Function to connect to the database
def connect_to_database():
    mydb = mysql.connector.connect(
        host="recipekeepdatabase.c5nrqmbdunio.us-east-2.rds.amazonaws.com",
        user="jjjmlrecipes",
        password="Maincra2024"
    )
    return mydb


# Function to classify a recipe based on ingredients
# modified diet sets and checking condition to return true if atleast one ingredient is found in a diet set
def classify_recipe(ingredients):
    lactose_free = {'milk', 'cheese', 'yogurt', 'cream', 'butter', 'curd', 'sour cream', 'buttermilk', 'margarine'}
    gluten_free = {'yeast', 'flour', 'wheat', 'bread', 'bread crumbs', 'beer', 'rye', 'barley', 'pasta', 'dough',
                   'macaroni', 'cake'}
    vegetarian = {'beef', 'chicken', 'eggs', 'egg', 'hamburger', 'pepperoni',
                  'sausage', 'bologna', 'bacon', 'pork', 'lamb', 'fish', 'shrimp', 'salmon', 'tuna', 'cod', 'anchovy', 'steak', 'milk', 'chocolate'
                  , 'condensed milk'}
    vegan = {'gelatin', 'honey', 'whey', 'ghee', 'lard', 'collagen', 'mayo', 'mayonnaise', 'cake mix', 'cool whip'}

    contains_non_vegan = any(
        any(ingredient in diet_ingredient for diet_ingredient in vegan.union(vegetarian.union(lactose_free))) for
        ingredient in ingredients)

    contains_non_vegetarian = any(any(ingredient in diet_ingredient for diet_ingredient in vegetarian) for
                                  ingredient in ingredients)

    contains_lactose = any(any(ingredient in diet_ingredient for diet_ingredient in lactose_free) for
                           ingredient in ingredients)

    contains_gluten = any(any(ingredient in diet_ingredient for diet_ingredient in gluten_free) for
                          ingredient in ingredients)

    diet = set()
    if not contains_gluten:
        diet.add('Gluten-Free')
    if not contains_non_vegetarian:
        diet.add('Vegetarian')
    if not contains_lactose:
        diet.add('Lactose-Free')
    if not contains_non_vegan:
        diet.add('Vegan')
    if len(diet) == 0:
        diet.add('No Restrictions')
    return diet


# Fetching and classifying recipes from the database
def pullRecipeFromDatabase():
    mydb = connect_to_database()
    cursor = mydb.cursor(buffered=True)
    cursor.execute("USE recipesdatabasesql")
    cursor.execute('SELECT * FROM full_dataset LIMIT 200')  # uses NER column instead of ingredients

    data = {'Recipes': [], 'DietCategory': []}
    row = cursor.fetchall()
    for recipe in row:
        new_recipe = (
        recipe[0], recipe[1], json.loads(recipe[2]), json.loads(recipe[3]), recipe[4], recipe[5], json.loads(recipe[6]))
        jsonify(json.loads(recipe[6]))
        diet_category = classify_recipe(new_recipe[6])
        data['Recipes'].append(new_recipe)
        data['DietCategory'].append(list(diet_category))

    # Close the database connection
    cursor.close()
    mydb.close()

    return data
