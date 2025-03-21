import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

// Clase ExpandableContent
class ExpandableContent {
  final String label;
  final String? stringValue; 
  final List<String>? stringListValue;
  final List<int>? intListValue;
  final List<double>? doubleListValue;
  final bool? boolValue;

  ExpandableContent( {
    required this.label,
    this.stringValue,
    this.intListValue, this.doubleListValue,    
    this.stringListValue,
    this.boolValue,
  });
}

// Método para generar contenido expandible
List<ExpandableContent> generateExpandableContent(List<List<dynamic>> data) {
  return data.map((item) {
    final String label = item[0] as String;
    final int tipo = item[1] as int;
    final dynamic value = item[2];

    switch (tipo) {
      case 1:
        return ExpandableContent(label: label,stringValue: value as String?);      
      case 2:
        return ExpandableContent(
            label: label, stringListValue: value as List<String>?);
      case 3:
        return ExpandableContent(
            label: label, intListValue: value as List<int>?);
      case 4:
        return ExpandableContent(
            label: label, doubleListValue: value as List<double>?);
      case 5:
        return ExpandableContent(label: label, boolValue: value as bool?);
      default:
        throw ArgumentError("Tipo no soportado: $tipo");
    }
  }).toList();
}

// Widget principal GradientExpandableCard
class GradientExpandableCard extends StatefulWidget {
  final String numeroindex;
  final String? titulo;
  final Map<String, String> subtitulos;
  final List<ExpandableContent> expandedContent;
  final VoidCallback ? onOpenModal;
  final bool hasErrors;
  final bool hasSend;
  final VoidCallback ? onSwipedAction; // Acción cuando se hace swipe  
  final int? idlista; // ID gestionado por el Provider

  const GradientExpandableCard({
    Key? key,
    required this.numeroindex,
    this.titulo,
    required this.subtitulos,
    required this.expandedContent,
    required this.onOpenModal,
    required this.hasErrors,
    required this.onSwipedAction,    
    required this.idlista, required this.hasSend,
  }) : super(key: key);

  @override
  _GradientExpandableCardState createState() => _GradientExpandableCardState();
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
    return SwipeableTile.card(
        horizontalPadding: 16,
        verticalPadding: 10,
        key: ValueKey(
            widget.idlista), // Identificador único del Provider
        swipeThreshold:0.5,
        resizeDuration: const Duration(milliseconds: 300),
        color: Colors.white,
        shadow: const BoxShadow(
          color: Colors.transparent,
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
         direction: widget.hasSend ? SwipeDirection.none : SwipeDirection.endToStart, // Desactiva swipe
        onSwiped: (_) => widget.onSwipedAction!(),
        backgroundBuilder: (context, direction, progress) {
          return Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          );
        },
        child: GestureDetector(
            onTap: widget.hasSend  ? () {} :(){
              widget.onOpenModal!();
            },
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.all(4),
                child: Column(children: [
                  // Encabezado fijo
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(20),
                        bottom: Radius.circular(_isExpanded ? 0 : 20),
                      ),
                      border: Border.all(color: Colors.grey, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 92, 91, 91)
                              .withOpacity(0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: widget.hasErrors
                                  ? const Color.fromARGB(255, 199, 64, 54)
                                  : Colors.blueAccent,
                            ),
                            Icon(
                              widget.hasErrors
                                  ? Icons.priority_high
                                  : Icons.check,
                              size: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 14,
                          height: 110,
                        ),
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
                                          widget
                                              .numeroindex, // Número dentro del círculo
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.titulo?.trim().isEmpty ?? true
                                              ? "Registro"
                                              : widget.titulo!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ...widget.subtitulos.entries
                                            .map((entry) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "${entry.key}: ",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: entry.value,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: _toggleExpand,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        minimumSize: const Size(
                                            55, 40), // Tamaño mínimo del botón
                                        padding: const EdgeInsets.all(
                                            1), // Reduce el relleno interno
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Ajusta el tamaño al contenido
                                        children: [
                                          Icon(
                                            _isExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                              width:
                                                  0), // Ajusta este valor para reducir o aumentar el espacio
                                          const Text(
                                            "Ver",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),

                  // Contenido expandible
                  if (_isExpanded)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20)),
                        border: Border.all(color: Colors.grey, width: 1.0),
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
                                  "${content.label}: ",
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
                    )
                ]))));
  }
}

Widget _buildContentValue(ExpandableContent content) {
  if (content.stringValue != null) {
    return Text(content.stringValue!);
  } else if (content.stringListValue != null) {
    return Text(content.stringListValue!.join(", "));
  } else if (content.intListValue != null) {
    return Text(content.intListValue!.join(", ")); // Cambiado a intListValue
  } else if (content.doubleListValue != null) {
    return Text(content.doubleListValue!.join(", ")); // Cambiado a doubleListValue
  } else if (content.boolValue != null) {
    return Icon(
      content.boolValue! ? Icons.check : Icons.close,
      color: content.boolValue! ? Colors.green : Colors.red,
    );
  } else {
    return const Text("N/A");
  }
}
