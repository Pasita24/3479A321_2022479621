class Actividad {
  int? id;
  String fecha;
  String nombre;

  Actividad({this.id, required this.fecha, required this.nombre});

  // Método para convertir la instancia a Map para insertar en DB
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'fecha': fecha, 'nombre': nombre};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Método para crear la instancia desde Map (DB a objeto)
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(id: map['id'], fecha: map['fecha'], nombre: map['nombre']);
  }
}
