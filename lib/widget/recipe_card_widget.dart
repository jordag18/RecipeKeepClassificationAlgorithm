import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Utility.dart';
import '../model/recipe.dart';
import 'package:google_fonts/google_fonts.dart';

final _lightColors = [
  Colors.deepPurple.shade100,
  Colors.red.shade100,
  Colors.deepPurple.shade100,
  Colors.blue.shade100,
  Colors.purple.shade100,
  Colors.lime.shade100,
];

class RecipeCardWidget extends StatelessWidget {
  const RecipeCardWidget({
    Key? key,
    required this.recipe,
    required this.index,
  }) : super(key: key);

  final Recipe recipe;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(recipe.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (recipe.isFavorite)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ),
              Text(time,
                style: GoogleFonts.lato(
                  textStyle:
                  const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
        Stack(
          children:<Widget>[
            Text(
              recipe.title,
              style: GoogleFonts.lato(
                textStyle:
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black26,
                ),
              ),
            ),
            Text(
              recipe.title,
              style: GoogleFonts.lato(
                  textStyle:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ],
        ),

              const SizedBox(height: 8.0),
              if (recipe.photo_name != "") ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(child: Utility.imageFromBase64String(recipe.photo_name)),
              ),]


            ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}