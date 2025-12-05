import 'package:flutter/material.dart';
import '../services/mock_excel_service.dart';
import '../models/data_models.dart';
import '../widgets/background_wrapper.dart';

class CreateContractScreen extends StatefulWidget {
  const CreateContractScreen({super.key});

  @override
  State<CreateContractScreen> createState() => _CreateContractScreenState();
}

class _CreateContractScreenState extends State<CreateContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = MockExcelService();

  final TextEditingController _codigoVacanteController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  
  Area? _selectedArea;
  Position? _selectedPosition;
  DateTime _fechaInicio = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Nueva Contratación',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Codigo Vacante
                      TextFormField(
                        controller: _codigoVacanteController,
                        decoration: const InputDecoration(
                          labelText: 'Código Vacante (Nuevo Registro)',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) => value!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),

                      // Area Dropdown
                      DropdownButtonFormField<Area>(
                        value: _selectedArea,
                        decoration: const InputDecoration(
                          labelText: 'Área',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: _service.areas.map((area) {
                          return DropdownMenuItem(
                            value: area,
                            child: Text('${area.codigoArea} - ${area.descripcion}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedArea = value;
                            _selectedPosition = null; // Reset position when area changes
                          });
                        },
                        validator: (value) => value == null ? 'Seleccione un Área' : null,
                      ),
                      const SizedBox(height: 16),

                      // Position Dropdown (Filtered by Area)
                      DropdownButtonFormField<Position>(
                        value: _selectedPosition,
                        decoration: const InputDecoration(
                          labelText: 'Posición',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: _selectedArea == null 
                            ? [] 
                            : _service.getPositionsByArea(_selectedArea!.codigoArea).map((pos) {
                                return DropdownMenuItem(
                                  value: pos,
                                  child: Text('${pos.codigoPosicion} - ${pos.descripcion}'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPosition = value;
                          });
                        },
                        validator: (value) => value == null ? 'Seleccione una Posición' : null,
                      ),
                      const SizedBox(height: 16),

                      // Fecha Inicio
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _fechaInicio,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => _fechaInicio = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Inicio',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            "${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Observaciones
                      TextFormField(
                        controller: _observacionesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('GUARDAR CONTRATACIÓN'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _saveContract,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveContract() {
    if (_formKey.currentState!.validate()) {
      final newContract = Contract(
        codigoVacante: _codigoVacanteController.text,
        codigoArea: _selectedArea!.codigoArea,
        codigoPosicion: _selectedPosition!.codigoPosicion,
        fechaInicio: _fechaInicio,
        observaciones: _observacionesController.text,
      );

      _service.createContract(newContract);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contrato ${_codigoVacanteController.text} creado con 11 fases.')),
      );
      
      Navigator.pop(context);
    }
  }
}
