import 'package:flutter/material.dart';
import 'pages/registro_de_eventos.dart';
import 'pages/visualizacion_de_eventos.dart'
    as VisualizacionPage; // Alias para la clase VisualizacionDeEventosPage
import 'pages/acerca_de.dart';
import 'pages/funcion_de_seguridad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Delegados',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.brown), // Color de acento personalizado
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Delegados'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistroDeEventosPage()),
                );
              },
              child: Text('Registro de Eventos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizacionPage
                          .VisualizacionDeEventosPage()), // Utilizando el alias VisualizacionPage
                );
              },
              child: Text('Visualización de Eventos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcercaDePage()),
                );
              },
              child: Text('Acerca de'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FuncionDeSeguridadPage()),
                );
              },
              child: Text('Función de Seguridad'),
            ),
          ],
        ),
      ),
    );
  }
}
