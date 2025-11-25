import 'package:activity/screens/registrate.dart';
import 'package:activity/screens/viewUser.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'widget/drawer.dart';
import './widget/appBar.dart';
import 'screens/login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
        '/singIn': (context) => Registro(),
        '/viewUser': (context) => ViewUser(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      appBar: AppBarWidget.appBarPersonalizado('My Home Page', 28, Colors.white, TextAlign.center, FontWeight.bold),

      drawer: const DrawerWidget(),
      body: HomeScreen(),
    );
  }
}
