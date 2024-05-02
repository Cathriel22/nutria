import 'package:flutter/material.dart';
import 'package:nutria/pages/user_home.dart';

class ObjectiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutrIA'),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido por primera vez!',
              style: TextStyle(fontSize: 18.0),
                ),
            ObjectiveCard(
              title: 'Ganar Musculo',
              description: 'Pon tus músculos fuertes y gana fuerza',
              image: 'ganar.jpg',
            ),
            ObjectiveCard(
              title: 'Perder Grasa',
              description: 'Reduce tu índice de grasa, manteniéndote en forma',
              image: 'perder.jpg',
            ),
            ObjectiveCard(
              title: 'Mantener Peso',
              description: 'Mantén tu estilo de vida saludable',
              image: 'mantener.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

class ObjectiveCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  ObjectiveCard({required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('/$image'),
            backgroundColor: Colors.lightGreen,
            radius: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen, // Puedes cambiar este color según tus preferencias
          ),
            child: Text('Seleccionar'),
          ),
        ],
      ),
    );
  }
}


class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String peso = '';
  String estatura = '';
  String intensidad = 'Baja';
  List<MealCard> comidasFavoritas = [
    MealCard('Carbos', 'carbos.jpg'),
    MealCard('Proteinas', 'prot.jpg'),
    MealCard('Grasas', 'grasas.jpg'),
    MealCard('Verduras', 'verduras.jpg'),
    MealCard('Frutas', 'frutas.jpg'),
    MealCard('Bebidas', 'bebidas.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingrese sus datos'),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(child:       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  peso = value;
                });
              },
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  estatura = value;
                });
              },
              decoration: InputDecoration(labelText: 'Estatura (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),

            SizedBox(height: 10.0),
            Text('Comidas Favoritas'),
            Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: comidasFavoritas.map<Widget>((meal) {
                  return CheckboxListTile(
                    title: Text(meal.name),
                    value: meal.isSelected,
                    onChanged: (value) {
                      setState(() {
                        meal.isSelected = value!;
                      });
                    },
                    secondary: Image.asset(
                      '${meal.imageName}',
                      width: 40.0,
                      height: 40.0,
                    ),
                  );
                }).toList(),
              ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen, // Puedes cambiar este color según tus preferencias
            ),
              child: Text('Vamos'),
            ),
          ],
        ),
      ),
    )
    );

  }
}

class MealCard extends StatelessWidget {
  final String name;
  final String imageName;
  bool isSelected = false;

  MealCard(this.name, this.imageName);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(name),
      value: isSelected,
      onChanged: (value) {
        isSelected = value!;
      },
      secondary: Image.asset(
        '$imageName',
        width: 40.0,
        height: 40.0,
      ),
    );
  }
}
