import 'package:flutter/material.dart';
import '../core/text_styles.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 250,
              child: Card(
                color: Colors.white,
                elevation: 50,
                shadowColor: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                        child: TextConstructor.styleTxt('Welcome to Actions Of Users', 26, Colors.black, TextAlign.center, FontWeight.bold)
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                        child: TextConstructor.styleTxt('This is a simple acction for user in the application app.', 16, const Color.fromARGB(255, 251, 118, 167), TextAlign.center, FontWeight.w700),
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
