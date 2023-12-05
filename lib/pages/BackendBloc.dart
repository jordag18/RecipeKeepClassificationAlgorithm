import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../db/recipes_database.dart';
import '../model/recipe.dart';


class BackendBloc extends Cubit<String> {
  BackendBloc() : super('');

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/pull'));
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
          photo_name: "",
          createdTime: DateTime.now(),
          link: recipe[4]
        );
        await RecipesDatabase.instance.create(new_recipe);
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<String> fetchPredict(features) async {
    var url = Uri.parse('http://10.0.2.2:5000/predict');
    var response = await http.post(
        url, body: json.encode({'features': features}));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['prediction'].join(', ').toString();
    } else {
      print("Error Code: ${response.statusCode} ${response.body}");
      throw Exception('Failed to load prediction');
    }
  }
}