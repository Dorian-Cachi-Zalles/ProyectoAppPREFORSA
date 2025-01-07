import 'package:flutter/material.dart';

class ExpandableContent {
  final String label;
  final String? stringValue;
  final List<int>? intListValue;
  final List<double>? doubleListValue;
  final List<String>? stringListValue;
  final bool? boolValue;

  ExpandableContent({
    required this.label,
    this.stringValue,
    this.intListValue,
    this.doubleListValue,
    this.stringListValue,
    this.boolValue,
  });
}

class GradientExpandableCard extends StatefulWidget {
  final String title;
  final String?title2;
  final String subtitletitulo;
  final String subtitle;
  final String ?subtitle2titulo;
  final String ?subtitle2;
  final List<ExpandableContent> expandedContent;
  final VoidCallback onOpenModal;
  final bool hasErrors;

  const GradientExpandableCard({
    super.key,
    required this.title,
    this.title2,
    required this.subtitle,
    required this.expandedContent,
    required this.onOpenModal,
    required this.hasErrors, this.subtitle2,required this.subtitletitulo, this.subtitle2titulo,
  });

  @override
  State<GradientExpandableCard> createState() => _GradientExpandableCardState();
}

class _GradientExpandableCardState extends State<GradientExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Encabezado fijo
          Container(
            decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
            child: Row(
              children: [
                // Indicador de errores
                Container(
                  width: 35,
                  height: 100,
                  decoration: BoxDecoration(
                    color: widget.hasErrors
                        ? const Color.fromARGB(255, 211, 60, 49)
                        : const Color.fromARGB(255, 95, 211, 49),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Icon(
                    widget.hasErrors ? Icons.warning : Icons.check_circle,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                // Contenido de título y subtítulo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // Círculo con número
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.title, // Número dentro del círculo
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Título y hora
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                            (widget.title2 == null || widget.title2!.trim().isEmpty) ? 
                            "Registro" : 
                            widget.title2!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3,),
                             RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.subtitletitulo, // Parte en bold
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.subtitle, // Parte normal
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                             widget.subtitle2 != null && widget.subtitle2!.trim().isNotEmpty
                            ? RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.subtitle2titulo, // Parte en bold
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.subtitle2, // Parte normal
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón expandir/colapsar
                ElevatedButton.icon(
                  onPressed: _toggleExpand,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  ),
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Ver",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          // Contenido expandible
          if (_isExpanded)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: widget.expandedContent.map((content) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildContentValue(content),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Método para construir el widget basado en el tipo de valor
  Widget _buildContentValue(ExpandableContent content) {
    if (content.stringValue != null) {
      return Text(content.stringValue!);
    } else if (content.intListValue != null) {
      return Text(content.intListValue!.join(", "));
    } else if (content.doubleListValue != null) {
      return Text(content.doubleListValue!.join(", "));
    } else if (content.stringListValue != null) {
      return Text(content.stringListValue!.join(", "));
    } else if (content.boolValue != null) {
      return Icon(
        content.boolValue! ? Icons.check : Icons.close,
        color: content.boolValue! ? Colors.green : Colors.red,
      );
    } else {
      return const Text("N/A");
    }
  }
}
