
import 'package:flutter/material.dart';
import '../screens/extra.dart';
import '../screens/contactanos.dart';
import '../screens/list_view_users.dart';
import '../screens/registrate.dart';
import '../core/text_styles.dart';
import '../screens/users/users_list_page.dart';
import '../screens/login.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(
        //permite construir objetos complejos paso a paso y optimizar el rendimiento
        builder: (BuildContext context) {
          return Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.pink),
                child: Row(
                  children: [
                    Icon(Icons.accessibility, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    TextConstructor.styleTxt('Activity Menu', 26, Colors.white, TextAlign.start, FontWeight.bold),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  //  sirve para mostrar una lista desplazable de widgets
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.home_outlined,
                        color: Colors.pink,
                      ),
                      title: TextConstructor.styleTxt('Home', 18, Colors.black, TextAlign.start, FontWeight.w500),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.badge_outlined,
                    //     color: Colors.pink,
                    //   ),
                    //   title: TextConstructor.styleTxt('Additional Data', 18, Colors.black, TextAlign.start, FontWeight.w500),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const ExtraData(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.phone_android_outlined,
                    //     color: Colors.pink,
                    //   ),
                    //   title: TextConstructor.styleTxt('Contact Us', 18, Colors.black, TextAlign.start, FontWeight.w500),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const Contactanos(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.view_list_outlined,
                    //     color: Colors.pink,
                    //   ),
                    //   title: TextConstructor.styleTxt('View List', 18, Colors.black, TextAlign.start, FontWeight.w500),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => UsersListPage(),
                    //       ),
                    //     );
                    //   },
                    // ),

                    const Divider(height: 20),

                    ListTile(
                      leading: const Icon(
                        Icons.login,
                        color: Colors.pink,
                      ),
                      title: TextConstructor.styleTxt('Log in', 18, Colors.black, TextAlign.start, FontWeight.w500),
                      onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                    ),


                    ListTile(
                      leading: const Icon(
                        Icons.person_add,
                        color: Colors.pink,
                      ),
                      title: TextConstructor.styleTxt('Sign in', 18, Colors.black, TextAlign.start, FontWeight.w500),
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
                    label: TextConstructor.styleTxt('Close Menu', 20, Colors.white, TextAlign.start, FontWeight.w500),
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
              SizedBox(height: 40)
            ],
          );
        },
      ),
    );
  }
}
