import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/Utility.dart';

class RecipeFormWidget extends StatelessWidget {
  final bool? isFavorite;
  final String? title;
  final String? ingredients;
  final String? instructions;
  final String? nutrition;
  final String? tags;
  final String? photo_name;
  final String? link;
  final ValueChanged<bool> onChangedFavorite;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedIngredients;
  final ValueChanged<String> onChangedInstructions;
  final ValueChanged<String> onChangedNutrition;
  final ValueChanged<String> onChangedTags;
  final ValueChanged<String> onChangedPhoto_Name;
  final ValueChanged<String> onChangedLink;


  const RecipeFormWidget({
    Key? key,
    this.title = '',
    this.isFavorite = false,
    this.ingredients = '',
    this.instructions = '',
    this.nutrition = '',
    this.tags = '',
    this.photo_name = '',
    this.link = '',
    required this.onChangedFavorite,
    required this.onChangedTitle,
    required this.onChangedIngredients,
    required this.onChangedInstructions,
    required this.onChangedNutrition,
    required this.onChangedTags,
    required this.onChangedPhoto_Name,
    required this.onChangedLink,
  }) : super(key: key);

  pickImageFromGallery() {
    var imgString;
    var image = ImagePicker().pickImage(source: ImageSource.gallery);
    image.then((imgFile) {
      var tempImage = imgFile?.readAsBytes();
      tempImage?.then((temp) {
        imgString = Utility.base64String(temp);
        onChangedPhoto_Name(imgString);
      });
    });
    return imgString;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(

    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Favorite',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Switch(
                value: isFavorite ?? false,
                onChanged: onChangedFavorite,
              ),
              //Expanded(child: Slider(value: (number ?? 0).toDouble(), min: 0, max: 5, divisions: 5, onChanged: (number) => onChangedNumber(number.toInt()),))
            ],
          ),
          buildTitle(),
          if (photo_name != '')
            Container(child: Utility.imageFromBase64String(photo_name!)),
          const SizedBox(height: 8),
          ElevatedButton(

              onPressed: () {
                pickImageFromGallery();
                },
              child: const Text(
                "Add Photo"
              ),
          ),
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
          buildLink(),
          const SizedBox(height: 10),
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
          buildIngredients(),
          const SizedBox(height: 10),
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
          buildInstructions(),
          const SizedBox(height: 10),
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
          buildNutrition(),
          const SizedBox(height: 8),
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
          buildTags(),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) =>
    title != null && title.isEmpty
        ? 'The title cannot be empty'
        : null,
    onChanged: onChangedTitle,
  );

  Widget buildLink() => TextFormField(
    maxLines: 15,
    initialValue: link,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    onChanged: onChangedIngredients,
  );

  Widget buildIngredients() => TextFormField(
    maxLines: 15,
    initialValue: ingredients,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: onChangedIngredients,
  );

  Widget buildInstructions() => TextFormField(
    maxLines: 20,
    initialValue: instructions,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The instructions cannot be empty'
        : null,
    onChanged: onChangedInstructions,
  );

  Widget buildNutrition() => TextFormField(
    maxLines: 20,
    initialValue: nutrition,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The diet cannot be empty'
        : null,
    onChanged: onChangedNutrition,
  );

  Widget buildTags() => TextFormField(
    maxLines: 20,
    initialValue: tags,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Enter tags with a space between each tag.',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The tags cannot be empty'
        : null,
    onChanged: onChangedTags,
  );

}