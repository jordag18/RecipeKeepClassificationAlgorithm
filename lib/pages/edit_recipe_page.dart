
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_keep_project/db/recipes_database.dart';
import 'package:recipe_keep_project/model/recipe.dart';
import 'package:recipe_keep_project/pages/BackendBloc.dart';
import '../widget/recipe_form_widget.dart';

class AddEditRecipePage extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipePage({
    Key? key,
    this.recipe,
  }) : super(key: key);
  @override
  _AddEditRecipePageState createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isFavorite;
  late String title;
  late String instructions;
  late String ingredients;
  late String nutrition;
  late String tags;
  late String photo_name;
  late String link;

  @override
  void initState() {
    super.initState();

    isFavorite = widget.recipe?.isFavorite ?? false;
    title = widget.recipe?.title ?? '';
    ingredients = widget.recipe?.ingredients ?? '';
    instructions = widget.recipe?.instructions ?? '';
    nutrition = widget.recipe?.nutrition ?? '';
    tags = widget.recipe?.tags ?? '';
    photo_name = widget.recipe?.photo_name ?? '';
    link = widget.recipe?.link ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var backendBloc = BlocProvider.of<BackendBloc>(context);
    return Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: RecipeFormWidget(
        isFavorite: isFavorite,
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        nutrition: nutrition,
        tags: tags,
        photo_name: photo_name,
        link: link,
        onChangedFavorite: (isFavorite) =>
            setState(() => this.isFavorite = isFavorite),
        onChangedTitle: (title) =>
            setState(() => this.title = title),
        onChangedIngredients: (ingredients) =>
            setState(() => this.ingredients = ingredients),
        onChangedInstructions: (instructions) =>
            setState(() => this.instructions = instructions),
        onChangedNutrition: (nutrition) =>
            setState(() => this.nutrition = nutrition),
        onChangedTags: (tags) =>
            setState(() => this.tags = tags),
        onChangedPhoto_Name: (photo_name) =>
            setState(() => this.photo_name = photo_name),
        onChangedLink: (link) =>
            setState(() => this.link = link),
      ),
    ),
  );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && ingredients.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.purple,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: () {
          addOrUpdateRecipe();
        },
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateRecipe() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.recipe != null;

      if (isUpdating) {
        await updateRecipe();
      } else {
        await addRecipe();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateRecipe() async {
    final recipe = widget.recipe!.copy(
      isFavorite: isFavorite,
      title: title,
      ingredients: ingredients,
      instructions: instructions,
      nutrition: await BlocProvider.of<BackendBloc>(context).fetchPredict(tags.split(',')),
      tags: tags,
      photo_name: photo_name,
      link: link,
    );

    await RecipesDatabase.instance.update(recipe);
  }

  Future addRecipe() async {
    final recipe = Recipe(
      title: title,
      isFavorite: isFavorite,
      ingredients: ingredients,
      instructions: instructions,
      nutrition: await BlocProvider.of<BackendBloc>(context).fetchPredict(tags.split(',')),
      tags: tags,
      photo_name: photo_name,
      createdTime: DateTime.now(),
      link: link,
    );

    await RecipesDatabase.instance.create(recipe);
  }
}
