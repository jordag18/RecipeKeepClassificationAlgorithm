import 'package:flutter/material.dart';
import 'package:recipe_keep_project/model/Utility.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../db/recipes_database.dart';
import '../model/recipe.dart';
import 'edit_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Recipe recipe;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshRecipe();
  }

  Future refreshRecipe() async {
    setState(() => isLoading = true);

    recipe = await RecipesDatabase.instance.readRecipe(widget.recipeId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
            children: [
              Text(
                recipe.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (recipe.isFavorite)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ),
            ],
            ),
          ),
          if (recipe.photo_name != '') ...[Container(child: Utility.imageFromBase64String(recipe.photo_name))],
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Link:',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            child: Text(
              recipe.link,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            onDoubleTap: () => _launchUrl(),
          ),
          const SizedBox(height: 8),
          //Text(DateFormat.yMMMd().format(note.createdTime), style: TextStyle(color: Colors.white38),),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ingredients:',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.ingredients,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Instructions:',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.instructions,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Diet Tags:',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.nutrition,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tags:',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.tags,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined, color: Colors.white60),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditRecipePage(recipe: recipe),
        ));

        refreshRecipe();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete, color: Colors.white60),
    onPressed: () async {
      await RecipesDatabase.instance.delete(widget.recipeId);

      Navigator.of(context).pop();
    },
  );

  _launchUrl() async {
    if (!await launchUrl(Uri.parse("http://${recipe.link}"))) {
      throw Exception('Could not launch ${Uri.parse(recipe.link)}');
    }
  }
}