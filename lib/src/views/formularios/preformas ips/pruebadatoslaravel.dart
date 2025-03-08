import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/services/bdpreformas.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/model_mensaje_prueba.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/servicio_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessagesPage2 extends StatefulWidget {
  const MessagesPage2({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage2> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<Message> messages = [];
  final MessageService service = MessageService();
  int? currentId;
  String messageText = '';
  int messageNumber = 0;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadMessageId();
  }

  Future<void> loadMessageId() async {
    final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
    final id = await provider.getActiveMessage();
    setState(() {
      currentId = id;
      isEditing = currentId != null;
    });
  }

 void createMessage() async { 
  try {
    // Crear un nuevo mensaje con valores predeterminados
    final newMessage = Message(
      message: 'Mensaje predeterminado', // Valor por defecto
      number: 0, // Si es nulo o vacío, asigna 0
    );

    // Enviar el mensaje al servicio para crearlo en Laravel
    final createdMessage = await service.createMessage(newMessage);

    // Guardar el ID en el Provider
    final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
    await provider.saveActiveMessage(createdMessage.id!);

    setState(() {
      currentId = createdMessage.id;
      isEditing = true;
    });

    _formKey.currentState?.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensaje creado con éxito')),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al crear mensaje: $e')),
    );
  }
}


  void updateMessage() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final values = _formKey.currentState!.value;
        final updatedMessage = Message(
          id: currentId,
          message: values['message'],
          number: int.parse(values['number']),
        );

        await service.updateMessage(updatedMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mensaje actualizado correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar mensaje')),
        );
      }
    }
  }

  void finishProcess() async {
    final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
    await provider.finishProcess();
    setState(() {
      currentId = null;
      isEditing = false;
      messageText = '';
      messageNumber = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: isEditing
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'message',
                      decoration: InputDecoration(labelText: 'Mensaje'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'number',
                      decoration: InputDecoration(labelText: 'Número'),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateMessage,
                      child: const Text('Actualizar'),
                    ),
                    ElevatedButton(
                      onPressed: finishProcess,
                      child: const Text('Terminar Registro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: ElevatedButton(
                onPressed: createMessage,
                child: const Text('¿Quiere crear un registro?'),
              ),
            ),
    );
  }
}
