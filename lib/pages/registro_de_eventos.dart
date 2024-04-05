import 'package:flutter/material.dart';
import 'package:elecciones_20211263/database/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class RegistroDeEventosPage extends StatefulWidget {
  @override
  _RegistroDeEventosPageState createState() => _RegistroDeEventosPageState();
}

class _RegistroDeEventosPageState extends State<RegistroDeEventosPage> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  DateTime? _fechaSeleccionada;
  String? _fotoPath;
  String? _audioPath;

  final ImagePicker _imagePicker = ImagePicker();
  final FilePicker _filePicker = FilePicker.platform;

  late DatabaseManager _databaseManager;

  @override
  void initState() {
    super.initState();
    _databaseManager = DatabaseManager();
    _abrirBaseDeDatos();
  }

  Future<void> _abrirBaseDeDatos() async {
    await _databaseManager.initializeDatabase();
  }

  Future<void> _guardarRegistro(BuildContext context) async {
    String titulo = _tituloController.text;
    String descripcion = _descripcionController.text;
    String fecha =
        _fechaSeleccionada != null ? _fechaSeleccionada.toString() : '';

    if (titulo.isNotEmpty && descripcion.isNotEmpty && fecha.isNotEmpty) {
      await _databaseManager.insertRegistro({
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
        'foto': _fotoPath ?? '',
        'audio': _audioPath ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registro guardado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );

      _limpiarCampos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _limpiarCampos() {
    _tituloController.clear();
    _descripcionController.clear();
    _fechaSeleccionada = null;
    _fotoPath = null;
    _audioPath = null;
  }

  Future<void> _seleccionarFoto() async {
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _fotoPath = pickedFile.path;
        }
      });
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  Future<void> _seleccionarAudio() async {
    try {
      FilePickerResult? result = await _filePicker.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      setState(() {
        if (result != null && result.files.isNotEmpty) {
          _audioPath = result.files.first.path;
        }
      });
    } catch (e) {
      print('Error al seleccionar el audio: $e');
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaSeleccionada = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Eventos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: Text('Seleccionar Fecha'),
                ),
                if (_fechaSeleccionada != null)
                  Text(
                      'Fecha seleccionada: ${_fechaSeleccionada!.toString().split(' ')[0]}'),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _seleccionarFoto,
              child: Text('Seleccionar Foto'),
            ),
            SizedBox(height: 8),
            if (_fotoPath != null)
              Image.file(
                File(_fotoPath!),
                width: 100,
                height: 100,
              ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _seleccionarAudio,
              child: Text('Seleccionar Audio'),
            ),
            SizedBox(height: 8),
            if (_audioPath != null)
              Text('Archivo de audio seleccionado: $_audioPath'),
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
    );
  }
}
