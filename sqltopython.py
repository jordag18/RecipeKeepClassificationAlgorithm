# Importing module 
import mysql.connector
import json

# Creating connection object
mydb = mysql.connector.connect(
	host = "recipekeepdatabase.c5nrqmbdunio.us-east-2.rds.amazonaws.com",
	user = "jjjmlrecipes",
	password = "Maincra2024"
)

# Printing the connection object to veryfy connection to MySQL server.
#print(mydb)

# Creating an instance of 'cursor' class 
# which is used to execute the 'SQL' 
# statements in 'Python'
cursor = mydb.cursor()

# Show database to choose the correct databse schema
#cursor.execute("SHOW DATABASES")

# Choose the database in which the dataset is located
cursor.execute("USE recipesdatabasesql")


# Execute a query on the 'full_dataset' table
cursor.execute('SELECT * FROM full_dataset')


row = cursor.fetchone()

# Assuming the order of columns is as follows:
# recipeID (int), title (text), ingredients (json), directions (json), link (text), source (text), NER (json)
for i in range (1):
    recipeID = row[0]  # Integer
    title = row[1]  # String
    ingredients = json.loads(row[2])  # Parse JSON string into a Python dictionary
    directions = json.loads(row[3])  # Parse JSON string into a Python dictionary
    link = row[4]  # String
    source = row[5]  # String
    NER = json.loads(row[6])  # Parse JSON string into a Python dictionary

    # Do something with the data, for example, print it
    print(f"Recipe ID: {recipeID}")
    print(f"Title: {title}")
    print(f"Ingredients: {ingredients}")
    print(f"Directions: {directions}")
    print(f"Link: {link}")
    print(f"Source: {source}")
    print(f"NER: {NER}")

def fetch_unique_ner_entities(mydb):
    # Initialize a set to store unique NER values
    unique_ners = set()
    cursor.execute('SELECT NER FROM full_dataset')
    row = cursor.fetchone()

    while row:
        # Parse the NER JSON string into a Python object
        try:
            ner_data = json.loads(row[0])
            for entity in ner_data:
                # Assuming each entity is a dictionary with 'text' and 'type' keys
                unique_ners.add(json.dumps(entity))  # Serialize the entity to a string to be able to add to a set
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")

        # Fetch the next result
        row = cursor.fetchone()
    return unique_ners

