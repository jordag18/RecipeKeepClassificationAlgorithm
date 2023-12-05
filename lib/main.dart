import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_keep_project/pages/BackendBloc.dart';
import 'package:recipe_keep_project/pages/recipes_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<BackendBloc>(
            create: (context) =>
                BackendBloc(),
          )
        ],
        child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  static const String title = 'RecipeKeep Beta';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    themeMode: ThemeMode.dark,
    theme: ThemeData(
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    home: RecipesPage(),
  );

}