class Contract {
  String codigoVacante;
  String codigoPosicion;
  String codigoArea;
  DateTime fechaInicio;
  String observaciones;

  Contract({
    required this.codigoVacante,
    required this.codigoPosicion,
    required this.codigoArea,
    required this.fechaInicio,
    required this.observaciones,
  });
}

class Phase {
  int codigoFase;
  String descripcion;

  Phase({required this.codigoFase, required this.descripcion});
}

class Area {
  String codigoArea;
  String descripcion;

  Area({required this.codigoArea, required this.descripcion});
}

class Position {
  String codigoPosicion;
  String descripcion;
  String codigoArea;

  Position({
    required this.codigoPosicion,
    required this.descripcion,
    required this.codigoArea,
  });
}

class PhaseTracking {
  String codigoVacante;
  int codigoFase;
  String codigoArea;
  String codigoResponsable;
  DateTime? fechaRecepcion;
  DateTime? fechaEntrega;

  PhaseTracking({
    required this.codigoVacante,
    required this.codigoFase,
    required this.codigoArea,
    this.codigoResponsable = '',
    this.fechaRecepcion,
    this.fechaEntrega,
  });
}
