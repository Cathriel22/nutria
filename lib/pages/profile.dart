// user_detail.dart
import 'package:flutter/material.dart';
import 'dart:convert'; // Importa el paquete para manejar JSON
import 'package:flutter/services.dart' show rootBundle;

class UsuarioDetalle extends StatefulWidget {
  @override
  _UsuarioDetalleState createState() => _UsuarioDetalleState();
}

class _UsuarioDetalleState extends State<UsuarioDetalle> {
  late Future<Map<String, dynamic>> usuario;

  @override
  void initState() {
    super.initState();
    usuario = cargarUsuario();
  }

  Future<Map<String, dynamic>> cargarUsuario() async {
    final String data = await rootBundle.loadString('json/user_profile.json');
    return json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    if (usuario == null) {
      // Muestra un indicador de carga mientras se carga el usuario
      return Scaffold(
        appBar: AppBar(
          title: Text('NutrIA'),
          backgroundColor: Colors.lightGreen,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('NutrIA'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: usuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se carga el usuario
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Maneja errores si ocurren durante la carga del usuario
            return Center(child: Text('Error al cargar el usuario'));
          } else {
            // Ahora puedes acceder a la variable 'usuario' de forma segura
            Map<String, dynamic> usuario = snapshot.data!;
            
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage(usuario['avatar']),
                    backgroundColor: Colors.lightGreen,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Nombre: ${usuario['nombre']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  Text(
                    'Edad: ${usuario['edad']} años',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  Text(
                    'Estatura: ${usuario['estatura']} cm',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  Text(
                    'Peso: ${usuario['peso']} kg',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  Text(
                    'Objetivo: ${usuario['objetivo']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}


