import 'package:flutter/material.dart';

class ScreenDashboard extends StatelessWidget {
  const ScreenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Calidad'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dashboard Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDashboardCard(
                  'Preformas Inspeccionadas', '5,000', Colors.blue),
              _buildDashboardCard('Defectos Detectados', '120', Colors.red),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDashboardCard('Tiempos de Servicio', '98%', Colors.green),
              _buildDashboardCard('Tasa de Defectos', '2.4%', Colors.orange),
            ],
          ),
          const SizedBox(height: 16),

          // Bar Chart
          const Text(
            'Reporte Semanal de Defectos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildBarChart(),
          ),
          const SizedBox(height: 16),

          // Activity Chart
          const Text(
            'Actividad Mensual',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: _buildActivityChart(),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true, // Para que no ocupe espacio infinito
            physics:
                const NeverScrollableScrollPhysics(), // Evita conflictos de desplazamiento
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Número de columnas
              crossAxisSpacing: 16, // Espaciado horizontal
              mainAxisSpacing: 16, // Espaciado vertical
              childAspectRatio: 2, // Relación de aspecto de cada celda
            ),
            itemCount: 6, // Número total de elementos
            itemBuilder: (context, index) {
              final items = [
                {
                  'title': 'Preformas',
                  'value': '10,000 unidades',
                  'color': Colors.blue,
                },
                {
                  'title': 'Tapas',
                  'value': '5,000 unidades',
                  'color': Colors.orange,
                },
                {
                  'title': 'Botellas',
                  'value': '3,000 unidades',
                  'color': Colors.green,
                },
                {
                  'title': 'Resina',
                  'value': '2,500 kg',
                  'color': Colors.purple,
                },
                {
                  'title': 'Producción',
                  'value': '4,000 unidades/día',
                  'color': Colors.red,
                },
                {'title': 'Defectos', 'value': '1.5%', 'color': Colors.grey},
              ];

              final item = items[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  border: Border.all(color: item['color'] as Color, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['value'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: item['color'] as Color,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Dashboard card widget
  Widget _buildDashboardCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Bar chart widget (mocked for simplicity)
  Widget _buildBarChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        7,
        (index) => Container(
          width: 20,
          height: (index == 0 ? 80 : index * 20).toDouble(),
          decoration: BoxDecoration(
            color: index == 0 ? Colors.red : Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // Activity chart widget (mocked for simplicity)
  Widget _buildActivityChart() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _LegendIndicator(color: Colors.blue, text: 'Preformas'),
            _LegendIndicator(color: Colors.orange, text: 'Tapas'),
            _LegendIndicator(color: Colors.red, text: 'Defectos'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              12,
              (index) => Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 12,
                      color: Colors.blue,
                      height: (index % 2 == 0 ? 50 : 30).toDouble(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Container(
                      width: 12,
                      color: Colors.orange,
                      height: (index % 3 == 0 ? 70 : 40).toDouble(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Container(
                      width: 12,
                      color: Colors.red,
                      height: (index % 4 == 0 ? 90 : 60).toDouble(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Legend indicator for activity
class _LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
