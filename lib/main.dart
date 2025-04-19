import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/firebase_options.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/providers/theme_provider.dart';
import 'package:wall_share/providers/wallpaper_provider.dart';
import 'package:wall_share/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize the environment variables file
  await dotenv.load(fileName: '.env');

  final themeProvider = ThemeProvider(false);
  final authProvider = AuthenticationProvider('');
  await themeProvider.loadTheme();
  await authProvider.checkIfUserLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.getTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
