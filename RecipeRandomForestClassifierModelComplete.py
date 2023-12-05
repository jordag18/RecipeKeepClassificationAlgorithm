import mysql.connector
import json
import pandas as pd
import pickle
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import accuracy_score

# Function to connect to the database
def connect_to_database():
    mydb = mysql.connector.connect(
        host="recipekeepdatabase.c5nrqmbdunio.us-east-2.rds.amazonaws.com",
        user="jjjmlrecipes",
        password="Maincra2024"
    )
    return mydb

# Function to classify a recipe based on ingredients
    #modified diet sets and checking condition to return true if atleast one ingredient is found in a diet set
def classify_recipe(ingredients):
    lactose_free = {'milk', 'cheese', 'yogurt', 'cream', 'butter', 'curd', 'sour cream'}
    gluten_free = {'yeast', 'flour', 'wheat', 'bread', 'bread crumbs', 'beer', 'rye', 'barley', 'pasta', 'dough', 'macaroni', 'cake'}
    vegetarian = {'beef', 'chicken', 'eggs', 'egg', 'hamburger', 'pepperoni',
                  'sausage', 'bologna', 'bacon', 'pork', 'lamb', 'fish', 'shrimp', 'salmon', 'tuna', 'cod', 'anchovy'}
    vegan = {'gelatin', 'honey', 'whey', 'ghee', 'lard', 'collagen'}

    contains_non_vegan = any(any(ingredient in diet_ingredient for diet_ingredient in vegan.union(vegetarian.union(lactose_free))) for
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
mydb = connect_to_database()
cursor = mydb.cursor()
cursor.execute("USE recipesdatabasesql")
cursor.execute('SELECT NER FROM full_dataset') # uses NER column instead of ingredients

data = {'NER': [], 'DietCategory': []}
row = cursor.fetchone()
while row:

    ingredients = json.loads(row[0])
    diet_category = classify_recipe(ingredients)
    data['NER'].append(' '.join(ingredients))
    data['DietCategory'].append(diet_category)
    row = cursor.fetchone()

df = pd.DataFrame(data)

# Close the database connection
cursor.close()
mydb.close()

# Feature Extraction
vectorizer = CountVectorizer()
X = vectorizer.fit_transform(df['NER'])

mlb = MultiLabelBinarizer() #used for multiple labels
y = mlb.fit_transform(df['DietCategory'])

# Splitting the dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)

# Train a Random Forest Classifier
clf = RandomForestClassifier()
clf.fit(X_train, y_train)

vec_file = 'vectorizer.pickle'
pickle.dump(vectorizer, open(vec_file, 'wb'))

mlb_file = 'mlb.pickle'
pickle.dump(mlb, open(mlb_file, 'wb'))

mod_file = 'classification.model'
pickle.dump(clf, open(mod_file, 'wb'))

# Predict and Evaluate
y_pred = clf.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))

