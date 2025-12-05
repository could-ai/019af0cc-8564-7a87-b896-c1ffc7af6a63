import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Placeholder for Logo
              const Icon(Icons.business, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 16),
              const Text(
                'Sistema de Control de Contrataciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              const Text(
                'CAAISA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildMenuButton(context, '1. Crear una nueva Contratación', Icons.add_circle_outline, '/create'),
              _buildMenuButton(context, '2. Actualizar un trámite', Icons.update, '/update'),
              _buildMenuButton(context, '3. Imprimir Estado', Icons.print, null),
              _buildMenuButton(context, '4. Listado de Contrataciones', Icons.list_alt, null),
              _buildMenuButton(context, '5. Dashboard de Control', Icons.dashboard, null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, String? route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(text, style: const TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueGrey,
            elevation: 2,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: () {
            if (route != null) {
              Navigator.pushNamed(context, route);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad en desarrollo')),
              );
            }
          },
        ),
      ),
    );
  }
}
