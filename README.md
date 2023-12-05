# RecipeKeepClassificationAlgorithm

 In the main branch the two .py files RecipeModelFlaskServer.py and RecipeDatabase.py are required to run model to predict a new recipe's ingredients and return the result. The RecipeRandomForestClassiferModelComplete.py code pulls the entire database and trains a new model and saves the model, vectorizer, and multilabelbinarizer that is used by
 RecipeModelFlaskServer.py to predict. Features for the model is the 'NER' category in the database, labels is the diets the recipe fits into. Model has an accuracy of 82%.

In the GUI branch the code for the flutter GUI creates an android apk that runs the GUI for RecipeKeep. The app pulls 200 recipes from the database during inital set up and are saved on the device for later. The app makes a request to the python flask server when a new recipe is added to retrieve and store the predicted values for diet tags.
When a recipe is edited a request is sent as well. Recipes can be searched by name, tags, and diets. 
