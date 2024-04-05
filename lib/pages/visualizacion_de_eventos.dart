import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class VisualizacionDeEventosPage extends StatefulWidget {
  @override
  _VisualizacionDeEventosPageState createState() =>
      _VisualizacionDeEventosPageState();
}

class _VisualizacionDeEventosPageState
    extends State<VisualizacionDeEventosPage> {
  late Database _database;
  List<Map<String, dynamic>> _eventos = [];
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _abrirBaseDeDatos();
  }

  Future<void> _abrirBaseDeDatos() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'registros_database.db'),
    );
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    final List<Map<String, dynamic>> eventos =
        await _database.query('registros');
    setState(() {
      _eventos = eventos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de Eventos'),
      ),
      body: ListView.builder(
        itemCount: _eventos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_eventos[index]['titulo'] ?? ''),
            subtitle: Text(_eventos[index]['fecha'] ?? ''),
            onTap: () {
              _verDetalleEvento(_eventos[index], context);
            },
          );
        },
      ),
    );
  }

  void _verDetalleEvento(Map<String, dynamic> evento, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(evento['titulo'] ?? ''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Descripción: ${evento['descripcion'] ?? ''}'),
              Text('Fecha: ${evento['fecha'] ?? ''}'),
              if (evento['foto'] != null && evento['foto'] != '')
                _buildImage(evento[
                    'foto']), // Utiliza un método para construir la imagen
              if (evento['audio'] != null)
                ElevatedButton(
                  onPressed: () {
                    _reproducirAudio(evento['audio']);
                  },
                  child: Text('Reproducir Audio'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String imagePath) {
    return Image.file(
      File(imagePath),
      width: 200,
      height: 200,
    );
  }

  void _reproducirAudio(String audioPath) async {
    await _audioPlayer.setUrl(audioPath);
    await _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
