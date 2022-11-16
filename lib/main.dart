import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';


void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false,)
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home'   :(context) => const HomeScreen(),
        'details':(context) => const DetailsScreen(),
      },
      
      theme: ThemeData().copyWith(
        appBarTheme: const  AppBarTheme(
          color: Colors.indigo
        ),
        scaffoldBackgroundColor: Colors.grey[300]
      ),
      // theme: ThemeData.dark().copyWith(
      //   appBarTheme: const  AppBarTheme(
      //     color: Colors.indigo
      //   ),
      // ),
    );
  }
}