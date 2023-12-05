import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../db/recipes_database.dart';
import '../model/recipe.dart';

class ServerConnector{
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/pull'));
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      print(decoded['Recipes'].join('\n'));
      decoded['Recipes'].forEach((recipe) async {
        var new_recipe = Recipe(
          title: recipe[1],
          isFavorite: false,
          ingredients: recipe[2].join('\n'),
          instructions: recipe[3].join('\n'),
          nutrition: decoded['DietCategory'][decoded['Recipes'].indexOf(recipe)].join(', ').toString(),
          tags: recipe[6].join(', '),
          photo_name: '',
          createdTime: DateTime.now(),
          link: recipe[4]
        );
        await RecipesDatabase.instance.create(new_recipe);
      });
    } else {
      print(response.statusCode);
    }
  }
}