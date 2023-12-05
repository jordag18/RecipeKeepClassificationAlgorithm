import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe_keep_project/db/recipes_database.dart';
import 'package:recipe_keep_project/model/recipe.dart';
import 'package:recipe_keep_project/pages/edit_recipe_page.dart';
import 'package:recipe_keep_project/pages/randomizer_page.dart';
import 'package:recipe_keep_project/pages/recipe_detail_page.dart';
import '../widget/recipe_card_widget.dart';
import '../widget/search_bar_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'BackendBloc.dart';

class RecipesPage extends StatefulWidget {
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late List<Recipe> recipes;
  bool isLoading = false;
  bool hasRun = false;
  List<String> ingredients = ['egg', 'corn', 'onion', 'cheddar', 'cheese', 'crackers', 'butter'];
  List sortBy = ['DA','DD', 'AA', 'AD', 'F'];
  dynamic sortByChoice = 'AA';
  StreamController<int> selected = StreamController<int>();

  @override
  void initState() {
    super.initState();
    if (!hasRun) {
      getRecipesFromDatabase();
    }
    refreshRecipes();
  }

  @override
  void dispose() {
    RecipesDatabase.instance.close();

    super.dispose();
  }

  Future refreshRecipes() async {
    setState(() => isLoading = true);

    recipes = await RecipesDatabase.instance.readAllRecipes(sortByChoice) as List<Recipe>;

    setState(() => isLoading = false);
  }

  Future getRecipesFromDatabase() async {
    setState(() => isLoading = true);
    await BackendBloc().fetchData();
    hasRun = true;
    refreshRecipes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final backendBloc = BlocProvider.of<BackendBloc>(context);
    return Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white60
      ),
      title: const Text(
        'RecipeKeep',
        style: TextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      actions: <Widget> [
        IconButton(
          tooltip: 'Refresh List',
          icon: const Icon(Icons.refresh_outlined, color: Colors.white,),
          onPressed: () async {
            refreshRecipes();

          },
        ),
        IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: searchBar(recipes)
              );
            },
            icon: const Icon(Icons.search), color: Colors.white,
        )
      ],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : recipes.isEmpty
          ? const Text(
        'No Recipes',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.white,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditRecipePage()),
        );

        refreshRecipes();
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar:_BottomAppBar(),
  );
  }

  Widget _BottomAppBar() => BottomAppBar(
    shape: const CircularNotchedRectangle(),
    color: Colors.deepPurpleAccent,
    child: IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 125.0),
          PopupMenuButton(
            initialValue: sortBy[3],
            onSelected: (value) {
              sortByChoice = value;
              refreshRecipes();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: sortBy[0],
                child: const Text('Date Created - Ascending'),
              ),
              PopupMenuItem(
                value: sortBy[1],
                child: const Text('Date Created - Descending'),
              ),
              PopupMenuItem(
                value: sortBy[2],
                child: const Text('Alphabetical - Ascending'),
              ),
              PopupMenuItem(
                value: sortBy[3],
                child: const Text('Alphabetical - Descending'),
              ),
              PopupMenuItem(
                value: sortBy[4],
                child: const Text('Favorite'),
              ),
            ],
            icon: const Icon(Icons.format_line_spacing),
          ),
          const Spacer(),
          /*
          IconButton(
            tooltip: 'Random',
            icon: const Icon(Icons.album_rounded),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RandomizerPage(recipes: recipes)));
            },
          ),

           */
          const SizedBox(width: 125.0),
        ],
      ),
    ),
  );

  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(8),
    itemCount: recipes.length,
    staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final recipe = recipes[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipeId: recipe.id!),
          ));

          refreshRecipes();
        },
        child: RecipeCardWidget(recipe: recipe, index: index),
      );
    },
  );
}
