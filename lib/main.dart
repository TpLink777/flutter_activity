import 'package:flutter/material.dart';
import 'registrate.dart';
import 'extra.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      appBar: AppBar(
        title: const Text(
          'Activity Home',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.pink),
                  child: Row(
                    children: const [
                      Icon(Icons.accessibility, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Activity Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home, color: Colors.pink),
                        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        onTap: () {
                          Navigator.of(context).pop(); // cierra el Drawer
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.badge, color: Colors.pink),
                        title: const Text('Additional Data', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExtraData(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.phone_android,
                          color: Colors.pink,
                        ),
                        title: const Text('Contac us', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      const Divider(height: 20),

                      ListTile(
                        leading: const Icon(
                          Icons.app_registration_outlined,
                          color: Colors.pink,
                        ),
                        title: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Registro(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //  Botón para cerrar menú
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Close Menu',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 200,
              child: Card(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Welcome to the Activity App!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'This is a simple Flutter application demonstrating an application.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
