import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'visualizacion_de_eventos.dart';

class AcercaDePage extends StatefulWidget {
  @override
  _AcercaDePageState createState() => _AcercaDePageState();
}

class _AcercaDePageState extends State<AcercaDePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _matriculaController = TextEditingController();

  late Database _database;

  @override
  void initState() {
    super.initState();
    _abrirBaseDeDatos();
  }

  Future<void> _abrirBaseDeDatos() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'registros_database.db'),
    );
  }

  Future<void> _guardarRegistro(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await _database.insert(
        'registros',
        {
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'matricula': _matriculaController.text,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      Navigator.pushReplacement(
        context, // Utiliza el contexto del widget para la navegación
        MaterialPageRoute(
          builder: (context) => VisualizacionDeEventosPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registro del Delegado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _matriculaController,
                decoration: InputDecoration(labelText: 'Matrícula'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la matrícula';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _guardarRegistro(context);
                },
                child: Text('Guardar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
