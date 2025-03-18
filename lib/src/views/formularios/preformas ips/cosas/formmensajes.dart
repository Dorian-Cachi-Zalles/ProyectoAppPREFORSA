import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/cosas/model_mensaje_prueba.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/cosas/servicio_api.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final MessageService service = MessageService();
  List<Message> messages = [];
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  void fetchMessages() async {
    try {
      final fetchedMessages = await service.getMessages();
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar mensajes')),
      );
    }
  }

  void createMessage() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final values = _formKey.currentState!.value;
        final newMessage = Message(
          message: values['message'],
          number: int.parse(values['number']),
        );

        await service.createMessage(newMessage);
        _formKey.currentState?.reset();
        fetchMessages();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear mensaje')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text('Número: ${message.number}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final editedMessage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMessagePage(message: message),
                            ),
                          );
                          if (editedMessage != null) {
                            fetchMessages();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await service.deleteMessage(message.id!);
                          fetchMessages();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'message',
                    decoration: const InputDecoration(labelText: 'Mensaje'),
                  ),
                  FormBuilderTextField(
                    name: 'number',
                    decoration: const InputDecoration(labelText: 'Número'),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.integer(),
                  ),
                  ElevatedButton(
                    onPressed: createMessage,
                    child: const Text('Crear Mensaje'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditMessagePage extends StatefulWidget {
  final Message message;

  const EditMessagePage({super.key, required this.message});

  @override
  _EditMessagePageState createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final MessageService service = MessageService();

  void updateMessage() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final values = _formKey.currentState!.value;

        final updatedMessage = Message(
          id: widget.message.id,
          message: values['message'],
          number: int.parse(values['number']),
        );

        await service.updateMessage(updatedMessage);
        Navigator.pop(context, updatedMessage);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar mensaje')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Mensaje')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'message': widget.message.message,
            'number': widget.message.number.toString(),
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'message',
                decoration: const InputDecoration(labelText: 'Mensaje'),
              ),
              FormBuilderTextField(
                name: 'number',
                decoration: const InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.integer(),
              ),
              ElevatedButton(
                onPressed: updateMessage,
                child: const Text('Actualizar Mensaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
