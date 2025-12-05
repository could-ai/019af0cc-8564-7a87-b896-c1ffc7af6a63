import '../models/data_models.dart';

class MockExcelService {
  // Singleton pattern
  static final MockExcelService _instance = MockExcelService._internal();
  factory MockExcelService() => _instance;
  MockExcelService._internal() {
    _initializeMockData();
  }

  List<Phase> fases = [];
  List<Area> areas = [];
  List<Position> posiciones = [];
  List<Contract> contratos = [];
  List<PhaseTracking> seguimientoFases = [];

  void _initializeMockData() {
    // Mocking TB_Fases (11 phases as requested)
    fases = List.generate(11, (index) => Phase(
      codigoFase: index + 1,
      descripcion: 'Fase ${index + 1} del Proceso',
    ));

    // Mocking TB_Areas
    areas = [
      Area(codigoArea: 'RH', descripcion: 'Recursos Humanos'),
      Area(codigoArea: 'IT', descripcion: 'Tecnología'),
      Area(codigoArea: 'FIN', descripcion: 'Finanzas'),
      Area(codigoArea: 'OPS', descripcion: 'Operaciones'),
    ];

    // Mocking TB_Posiciones
    posiciones = [
      Position(codigoPosicion: 'DEV01', descripcion: 'Desarrollador Junior', codigoArea: 'IT'),
      Position(codigoPosicion: 'DEV02', descripcion: 'Desarrollador Senior', codigoArea: 'IT'),
      Position(codigoPosicion: 'ANA01', descripcion: 'Analista Financiero', codigoArea: 'FIN'),
      Position(codigoPosicion: 'REC01', descripcion: 'Reclutador', codigoArea: 'RH'),
    ];
  }

  // Logic: Create Contract and generate 11 phases
  void createContract(Contract newContract) {
    contratos.add(newContract);

    // "Por cada Registro... se deberán crear tantas entradas... como fases contenga la tabla"
    for (var fase in fases) {
      seguimientoFases.add(PhaseTracking(
        codigoVacante: newContract.codigoVacante,
        codigoFase: fase.codigoFase,
        codigoArea: newContract.codigoArea, // Defaulting to contract area, can be changed
        fechaRecepcion: DateTime.now(), // Default start date
      ));
    }
  }

  List<PhaseTracking> getTrackingForContract(String codigoVacante) {
    return seguimientoFases.where((p) => p.codigoVacante == codigoVacante).toList();
  }
  
  List<Position> getPositionsByArea(String codigoArea) {
    return posiciones.where((p) => p.codigoArea == codigoArea).toList();
  }
}
