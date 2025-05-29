class Actividad {
  int? id;
  DateTime fecha;
  String nombre;

  Actividad({this.id, required this.fecha, required this.nombre});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'fecha': fecha.toIso8601String(),
      'nombre': nombre,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      fecha: DateTime.parse(map['fecha']),
      nombre: map['nombre'],
    );
  }
}
