from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.metrics import accuracy_score
import pandas as pd

# Sample dataset of recipes and their ingredients
recipes = {'Ingredients': [['tomato', 'basil', 'mozzarella'], ['beef', 'onion', 'garlic'], ['avocado', 'chicken', 'lime'], ['almond', 'honey', 'banana']],
           'DietLabels': [['vegetarian', 'gluten-free'], ['keto'], ['paleo'], ['vegan', 'gluten-free']]}
df = pd.DataFrame(recipes)

# Preprocessing the data
mlb = MultiLabelBinarizer()
X = pd.get_dummies(pd.DataFrame(df['Ingredients'].tolist()))
y = mlb.fit_transform(df['DietLabels'])

# Splitting the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)

# Creating the Random Forest classifier
clf = RandomForestClassifier()
clf.fit(X_train, y_train)

# Predicting on test data
y_pred = clf.predict(X_test)

# Evaluating the classifier
print("Accuracy:", accuracy_score(y_test, y_pred))

# Example: Classifying a new recipe
new_recipe = pd.DataFrame([{'0_almond': 0, '0_avocado': 0, '0_beef': 0, '0_tomato': 1, '1_basil': 0, '1_chicken': 0, '1_honey': 1, '1_onion': 1, '2_banana': 0, '2_garlic': 0, '2_lime': 0, '2_mozzarella': 0}])
prediction = clf.predict(new_recipe)
predicted_labels = mlb.inverse_transform(prediction)
print("Predicted diet labels for new recipe:", predicted_labels[0])