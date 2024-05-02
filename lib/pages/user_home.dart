import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nutria/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState  extends State<HomePage> {
  int _currentIndex = 0;
  late String nombreCompleto = '';
  // ignore: prefer_typing_uninitialized_variables
  late final userData;
  @override
  void initState() {
    super.initState();
    loadUserData(); // Llamar a la función en initState
  }

  Future<void> loadUserData() async {
  final userData = await getUserData();
  setState(() {
    nombreCompleto = userData['nombreCompleto'] ?? '';
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NutrIA'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, String> userData = snapshot.data!;
            String nombreCompleto = userData['nombreCompleto'] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mostrar el mensaje de bienvenida con la imagen del usuario
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
                        // Agregar la imagen redonda del usuario
                        ClipOval(
                          child: Image.asset(
                            '/user.jpg', // Asegúrate de que la ruta de la imagen sea correcta
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        // Agregar el mensaje de bienvenida
                        Text(
                          'Bienvenido, $nombreCompleto',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                // Cargar el menú después del mensaje de bienvenida
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: loadMenu(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<dynamic> menuData = snapshot.data!;
                        return buildMenu(context, menuData);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
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
                            '/user.jpg', // Asegúrate de que la ruta de la imagen sea correcta
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(height: 10),
                  Text(
                    
                    'Bienvenido, $nombreCompleto',
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


    Future<Map<String, String>> getUserData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String nombreCompleto = prefs.getString('nombreCompleto') ?? '';
      String correoElectronico = prefs.getString('correoElectronico') ?? '';
      print(nombreCompleto);
      print(correoElectronico);
      return {'nombreCompleto': nombreCompleto, 'correoElectronico': correoElectronico};
    }

    Future<List<dynamic>> loadMenu(BuildContext context) async {
      // Cargar el archivo JSON desde la ruta "base/data.json"
      String jsonContent = await DefaultAssetBundle.of(context).loadString('json/data.json');
      List<dynamic> menuData = json.decode(jsonContent)['dietas'];

      return menuData;
    }

  Widget buildMenu(BuildContext context, List<dynamic> menuData) {
    // Organizar los platillos por segmento
    Map<String, List<dynamic>> platillosPorSegmento = {};

    for (var dieta in menuData) {
      var comidas = dieta['comidas'];
      comidas.forEach((segmento, platillos) {
        if (platillosPorSegmento.containsKey(segmento)) {
          platillosPorSegmento[segmento]?.addAll(platillos);
        } else {
          platillosPorSegmento[segmento] = List.from(platillos);
        }
      });
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:Center(
            child: Text(
            "Menú del día",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightGreen
            ),
          ),
          )

        ),
        ...platillosPorSegmento.entries.map((entry) {
          String segmento = entry.key;
          List<dynamic> platillos = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  segmento.toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  selectionColor: Colors.lightGreenAccent
                ),
              ),
              ...platillos.map((platillo) {
                return ExpansionTile(
                  title: ListTile(
                    title: Text(platillo['nombre'],
                    style: TextStyle(color: Colors.black)),

                  ),
                  textColor: Colors.lightGreen[900],
                  backgroundColor: Colors.lightGreenAccent,
                  collapsedBackgroundColor: Colors.lightGreen,
                  iconColor: Colors.black, // Color verde cuando está colapsado
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ingredientes: ${platillo['ingredientes'].join(', ')}'),
                          Text('Preparación: ${platillo['preparacion']}'),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }
}
