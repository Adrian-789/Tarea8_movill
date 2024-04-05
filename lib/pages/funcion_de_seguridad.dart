import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FuncionDeSeguridadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Función de Seguridad'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _borrarRegistros(context);
          },
          child: Text('Borrar Todos los Registros'),
        ),
      ),
    );
  }

  Future<void> _borrarRegistros(BuildContext context) async {
    try {
      final databasePath = await getDatabasesPath();
      final database = await openDatabase(
        join(databasePath, 'registros_database.db'),
      );
      await database.delete('registros');
      await database.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos los registros han sido borrados.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al borrar los registros.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
