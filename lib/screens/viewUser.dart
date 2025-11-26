import 'package:flutter/material.dart';
import 'package:activity/widget/Post-Login/drawer-inicio-seccion.dart';
import '../widget/appBar.dart';
import '../screens/userScreenHome.dart';

class ViewUser extends StatelessWidget {
  const ViewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBarPersonalizado('User Screen', 28, Colors.white, TextAlign.center, FontWeight.bold),

      drawer: const DrawerWidget(),

      body: const UserScreen(),
    );
  }
}