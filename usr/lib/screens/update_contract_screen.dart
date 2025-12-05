import 'package:flutter/material.dart';
import '../services/mock_excel_service.dart';
import '../models/data_models.dart';
import '../widgets/background_wrapper.dart';

class UpdateContractScreen extends StatefulWidget {
  const UpdateContractScreen({super.key});

  @override
  State<UpdateContractScreen> createState() => _UpdateContractScreenState();
}

class _UpdateContractScreenState extends State<UpdateContractScreen> {
  final _service = MockExcelService();
  String? _selectedVacante;
  List<PhaseTracking> _currentPhases = [];

  @override
  Widget build(BuildContext context) {
    // Get list of available contracts for selection
    final contracts = _service.contratos;

    return BackgroundWrapper(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Actualizar Trámite',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              
              // Search/Select Contract
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedVacante,
                  decoration: const InputDecoration(
                    labelText: 'Seleccione Contrato / Vacante',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  items: contracts.map<DropdownMenuItem<String>>((Contract c) {
                    return DropdownMenuItem<String>(
                      value: c.codigoVacante,
                      child: Text('${c.codigoVacante} - Area: ${c.codigoArea}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVacante = value;
                      _currentPhases = _service.getTrackingForContract(value!);
                    });
                  },
                ),
              ),

              // List of Phases
              if (_selectedVacante != null)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blueGrey.withOpacity(0.1),
                        child: const Row(
                          children: [
                            Expanded(flex: 1, child: Text('Fase', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 3, child: Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Responsable', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Recepción', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Entrega', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 1, child: Text('Acción', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _currentPhases.length,
                          separatorBuilder: (ctx, i) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final phase = _currentPhases[index];
                            final phaseDesc = _service.fases.firstWhere((f) => f.codigoFase == phase.codigoFase).descripcion;
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(phase.codigoFase.toString())),
                                  Expanded(flex: 3, child: Text(phaseDesc)),
                                  Expanded(flex: 2, child: Text(phase.codigoResponsable.isEmpty ? '-' : phase.codigoResponsable)),
                                  Expanded(flex: 2, child: Text(phase.fechaRecepcion != null ? "${phase.fechaRecepcion!.day}/${phase.fechaRecepcion!.month}" : "-")),
                                  Expanded(flex: 2, child: Text(phase.fechaEntrega != null ? "${phase.fechaEntrega!.day}/${phase.fechaEntrega!.month}" : "-")),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editPhase(phase, phaseDesc),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Todos los cambios guardados correctamente.')),
                            );
                          },
                          child: const Text('ACTUALIZAR TODO'),
                        ),
                      )
                    ],
                  ),
                )
              else
                const Expanded(
                  child: Center(
                    child: Text('Seleccione una vacante para ver sus fases.'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _editPhase(PhaseTracking phase, String description) {
    final responsableCtrl = TextEditingController(text: phase.codigoResponsable);
    DateTime? fechaRec = phase.fechaRecepcion;
    DateTime? fechaEnt = phase.fechaEntrega;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Editar Fase ${phase.codigoFase}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: const TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                TextField(
                  controller: responsableCtrl,
                  decoration: const InputDecoration(labelText: 'Responsable', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(fechaRec == null ? 'Inicio' : "${fechaRec!.day}/${fechaRec!.month}/${fechaRec!.year}"),
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (d != null) setStateDialog(() => fechaRec = d);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(fechaEnt == null ? 'Fin' : "${fechaEnt!.day}/${fechaEnt!.month}/${fechaEnt!.year}"),
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (d != null) setStateDialog(() => fechaEnt = d);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    phase.codigoResponsable = responsableCtrl.text;
                    phase.fechaRecepcion = fechaRec;
                    phase.fechaEntrega = fechaEnt;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        }
      ),
    );
  }
}
