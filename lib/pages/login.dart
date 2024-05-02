import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nutria/pages/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nutritionist_home.dart';
import 'user_home.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class LoginPage extends StatelessWidget {

  
  String nombreCompleto = '';
  String correoElectronico = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NutrIA'),
          backgroundColor: Colors.lightGreen,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Log In'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña Log In
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(2.0),  // Ajusta el espacio alrededor de la imagen aquí
                    child: Image.asset(
                      '/login.jpg',  // Asegúrate de que la ruta de la imagen sea correcta
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration:  InputDecoration(
                      hintText: 'Correo electrónico',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      correoElectronico = value;
                      bool isValid = EmailValidator.validate(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      
                    ),
                    onChanged: (value){
                      password = value;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool loginSuccess = await loginUser(context, correoElectronico, password);
                    if (loginSuccess) {
                      _navigateToHomePage(context, correoElectronico);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Credenciales incorrectas. Intenta nuevamente.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  child: Text('Iniciar sesión'),
                ),
              ],
            ),

          // Contenido de la pestaña Sign Up
          Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(2.0),
        child: Image.asset(
          '/login.jpg',
          width: 200,
          height: 200,
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Nombre completo',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen),
          ),
        ),
        onChanged: (value) {
          nombreCompleto = value;
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          bool isValid = EmailValidator.validate(value);
          print('Is email valid? $isValid');
          correoElectronico = value;
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen),
          ),
        ),
        onChanged: (value) {
          password = value;
        },
      ),
    ),
    ElevatedButton(
      onPressed: () async {
        // Lógica de registro
        await saveUserData(nombreCompleto, correoElectronico);
        // ignore: use_build_context_synchronously
        _navigateToHomePage(context, correoElectronico);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
      ),
      child: const Text('Registrarse'),
    ),
  ],
),
  // Contenido de la pestaña Sign Up
          ],
        ),
      ),
    );
  }

  
  Future<bool> loginUser(BuildContext context, String email, String password) async {
    print(email);
    print(password);
    try {
      String jsonData = await DefaultAssetBundle.of(context).loadString('json/login.json');
      List<dynamic> users = json.decode(jsonData);

      for (var user in users) {
        if (user['email'] == email && user['contrasena'] == password) {
          return true;
        }
      }
    } catch (e) {
      print('Error al cargar el archivo JSON: $e');
    }

    return false;
  }

void _navigateToHomePage(BuildContext context, String email) async {
  try {
    String userType = await getUserType(context, email);
    print(userType);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (userType == 'user') {
            return ObjectiveView();
          } else if (userType == 'nutritionist') {
            return HomeNutritionist();
          } else {
            return Container(); // Manejar otro tipo de usuario si es necesario
          }
        },
      ),
    );
  } catch (e) {
    print('Error al obtener el tipo de usuario: $e');
  }
}


  // Agrega esta función al código
  Future<String> getUserType(BuildContext context, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String jsonData = await DefaultAssetBundle.of(context).loadString('json/login.json');
      List<dynamic> users = json.decode(jsonData);

      for (var user in users) {
        if (user['email'] == email) {
          prefs.setString('nombreCompleto', user['nombre']);
          return user['tipo'];
        }
      }
    } catch (e) {
      print('Error al cargar el archivo JSON de tipos de usuario: $e');
    }

    return ''; // Devuelve un valor predeterminado o maneja el caso de error según tus necesidades
  }


  // Función para guardar los datos del usuario localmente
  Future<void> saveUserData(String nombreCompleto, String correoElectronico) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombreCompleto', nombreCompleto);
    prefs.setString('correoElectronico', correoElectronico);
  }

  // Función para navegar a la página del usuario después de iniciar sesión o registrarse

}
