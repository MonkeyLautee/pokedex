import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'pages/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set device preffered orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Hive code for data persistence
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('cache');
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        // App colors
        primaryColor: Color.fromRGBO(6,144,233,1),
        colorScheme: const ColorScheme(
          primary: Color.fromRGBO(6,144,233,1),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(255,55,89,1),
          onSecondary: Colors.white,
          brightness: Brightness.light,
          error: Color.fromRGBO(255,55,89,1),
          onError: Colors.white,
          surface: Color.fromRGBO(240,240,240,1),
          onSurface: Colors.black,
        ),
        //Change the cursor style to fit the pokemon style
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromRGBO(6,144,233,1),
          selectionColor: Color.fromRGBO(255,55,89,0.36),
          selectionHandleColor: Color.fromRGBO(6,144,233,0.72),
        ),
        // Default text styles
        textTheme:const TextTheme(
          headlineMedium:TextStyle(
            color:Colors.black,
            fontWeight:FontWeight.bold,
            fontSize:19.0,
          ),
          bodyMedium:TextStyle(
            color:Colors.black,
            fontSize:17.0,
          ),
        ),
      ),
      home: const Wrapper(),
    );
  }
}