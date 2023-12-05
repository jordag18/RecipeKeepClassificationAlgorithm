import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recipe_keep_project/model/recipe.dart';

class RecipesDatabase {
  static final RecipesDatabase instance = RecipesDatabase._init();

  static Database? _database;

  RecipesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE $tableRecipes (
  ${RecipeFields.id} $idType, 
  ${RecipeFields.isFavorite} $boolType,
  ${RecipeFields.title} $textType,
  ${RecipeFields.instructions} $textType,
  ${RecipeFields.ingredients} $textType,
  ${RecipeFields.nutrition} $textType,
  ${RecipeFields.tags} $textType,
  ${RecipeFields.photo_name} $textType,
  ${RecipeFields.time} $textType,
  ${RecipeFields.link} $textType
  )
''');
  }

  Future<Recipe> create(Recipe recipe) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipes, recipe.toJson());
    return recipe.copy(id: id);
  }

  Future<Recipe> readRecipe(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Recipe.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List> readAllRecipes(sortBy) async {
    final db = await instance.database;
    var orderBy;
    if (sortBy == 'AA'){
      orderBy = '${RecipeFields.title} ASC';
    }
    else if(sortBy == 'DA'){
      orderBy = '${RecipeFields.time} ASC';
    }
    else if(sortBy == 'AD') {
      orderBy = '${RecipeFields.title} DESC';
    }
    else if(sortBy == 'DD'){
      orderBy = '${RecipeFields.time} DESC';
    }
    else if(sortBy == 'F'){
      orderBy = '${RecipeFields.isFavorite} DESC';
    }

    final result = await db.query(tableRecipes, orderBy: orderBy);

    return result.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<int> update(Recipe recipe) async {
    final db = await instance.database;

    return db.update(
      tableRecipes,
      recipe.toJson(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}