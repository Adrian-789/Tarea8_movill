// models/evento.dart

class Evento {
  final int id;
  final String titulo;
  final DateTime fecha;
  final String descripcion;
  final String foto;
  final String audio;

  Evento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.foto,
    required this.audio,
  });
}
