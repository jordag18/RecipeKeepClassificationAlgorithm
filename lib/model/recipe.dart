
final String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [
    id, isFavorite, title, instructions, ingredients, nutrition, tags, photo_name, time, link //time
  ];

  static final String id = '_id';
  static final String isFavorite = 'isFavorite';
  static final String title = 'title';
  static final String instructions = 'instructions';
  static final String ingredients = 'ingredients';
  static final String nutrition = 'nutrition';
  static final String tags = 'tags';
  static final String photo_name = 'photo_name';
  static final String time = 'time';
  static final String link = 'link';
}

class Recipe {
  final int? id;
  final bool isFavorite;
  final String title;
  final String instructions;
  final String ingredients;
  final String nutrition;
  final String tags;
  final String photo_name;
  final DateTime createdTime;
  final String link;


  const Recipe({
    this.id,
    required this.isFavorite,
    required this.title,
    required this.instructions,
    required this.ingredients,
    required this.nutrition,
    required this.tags,
    required this.photo_name,
    required this.createdTime,
    required this.link,
  });

  Recipe copy({
    int? id,
    bool? isFavorite,
    String? title,
    String? instructions,
    String? ingredients,
    String? nutrition,
    String? tags,
    String? photo_name,
    DateTime? createdTime,
    String? link,
  }) =>
      Recipe(
          id: id ?? this.id,
          isFavorite: isFavorite ?? this.isFavorite,
          title: title ?? this.title,
          instructions: instructions ?? this.instructions,
          ingredients: ingredients ?? this.ingredients,
          nutrition: nutrition ?? this.nutrition,
          tags: tags ?? this.tags,
          photo_name: photo_name ?? this.photo_name,
          createdTime: createdTime ?? this.createdTime,
          link: link ?? this.link,
      );

  static Recipe fromJson(Map<String, Object?> json) =>Recipe(
      id: json[RecipeFields.id] as int?,
      isFavorite: json[RecipeFields.isFavorite] == 1,
      title: json[RecipeFields.title] as String,
      instructions: json[RecipeFields.instructions] as String,
      ingredients: json[RecipeFields.ingredients] as String,
      nutrition: json[RecipeFields.nutrition] as String,
      tags: json[RecipeFields.tags] as String,
      photo_name: json[RecipeFields.photo_name] as String,
      createdTime: DateTime.parse(json[RecipeFields.time] as String),
      link: json[RecipeFields.link] as String);

  Map<String, Object?> toJson() => {
    RecipeFields.id: id,
    RecipeFields.title: title,
    RecipeFields.isFavorite: isFavorite ? 1: 0,
    RecipeFields.instructions: instructions,
    RecipeFields.ingredients: ingredients,
    RecipeFields.nutrition: nutrition,
    RecipeFields.tags: tags,
    RecipeFields.photo_name: photo_name,
    RecipeFields.time: createdTime.toIso8601String(),
    RecipeFields.link: link,
  };

}