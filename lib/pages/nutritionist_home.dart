import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutria/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeNutritionist extends StatefulWidget {
  @override
  _HomeNutritionist createState() => _HomeNutritionist();
}

class _HomeNutritionist extends State<HomeNutritionist> {
  int _currentIndex = 0;
  static String nombreCompletoGlobal = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userData = await getUserData();
    setState(() {
      nombreCompletoGlobal = userData['nombreCompleto'] ?? '';
    });
  }

  Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nombreCompleto = prefs.getString('nombreCompleto') ?? '';
    String correoElectronico = prefs.getString('correoElectronico') ?? '';
    print(nombreCompleto);
    print(correoElectronico);
    return {'nombreCompleto': nombreCompleto, 'correoElectronico': correoElectronico};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NutrIA'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadUsers(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<dynamic> users = snapshot.data!;
            return Column(
              children: [
                Card(
                  margin: EdgeInsets.all(16.0),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'user.jpg',
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          'Bienvenido, $nombreCompletoGlobal',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> userData = users[index];
                      return _buildUserCard(context, userData);
                    },
                  ),
                  
                ),
                
                
              ],

              
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
            drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aquí puedes poner la imagen del usuario y otros detalles.
                  ClipOval(
                          child: Image.asset(
                            'user.jpg', // Asegúrate de que la ruta de la imagen sea correcta
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(height: 10),
                  Text(
                    
                    'Bienvenido, $nombreCompletoGlobal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                // Lógica para navegar a la página de inicio.
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ver Perfil'),
              onTap: () {
                // Navega a la vista de detalle del usuario al seleccionar 'Ver Perfil'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuarioDetalle(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Lógica para navegar a la página de configuración.
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> userData) {
    String nombreCompletoCard = userData['nombreCompleto'] ?? '';
    String codigo = userData['codigo'] ?? '';

    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              nombreCompletoCard,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionCard(context, 'Datos', () {
                _showUserDataPopup(context, userData);
              }),
              _buildActionCard(context, 'Graficos', () {
                // Lógica para la acción "Graficos"
              }),
              _buildActionCard(context, 'Comidas', () {
                // Lógica para la acción "Comidas"
              }),
              _buildActionCard(context, 'Mensajes', () {
                // Lógica para la acción "Mensajes"
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> loadUsers(BuildContext context) async {
    try {
      String jsonContent = await DefaultAssetBundle.of(context).loadString('json/usuarios.json');
      Map<String, dynamic> jsonData = json.decode(jsonContent);

      List<dynamic> users = jsonData['usuarios'] ?? [];
      return users;
    } catch (e) {
      print("Error cargando usuarios: $e");
      return List<dynamic>.empty();
    }
  }

  void _showUserDataPopup(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Usuario'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'user2.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text('Nombre Completo: ${userData['nombreCompleto']}'),
              Text('Código: ${userData['codigo']}'),
              Text('Edad: ${userData['edad']}'),
              Text('Peso: ${userData['peso']}'),
              Text('Altura: ${userData['altura']}'),
              Text('Calorías diarias: ${userData['cal']}'),
              Text('Proteínas: ${userData['prot']}'),
              Text('Carbohidratos: ${userData['carb']}'),
              Text('Grasas: ${userData['grasas']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
