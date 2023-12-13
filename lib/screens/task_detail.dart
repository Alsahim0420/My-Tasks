// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class TaskDetailScreen extends StatefulWidget {
  final int? index;

  const TaskDetailScreen({super.key, this.index});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _controller;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.index != null) {
      final task = Provider.of<TaskProvider>(context, listen: false)
          .tasks[widget.index!];
      _controller.text = task.title;
      _descriptionController.text = task.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.index == null ? 'Nueva Tarea' : 'Editar Tarea',
          style: const TextStyle(color: Colors.deepPurple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(labelText: 'Título de la tarea'),
            ),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descripción de la tarea'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveTask(context);
              },
              child: const Text('Guardar'),
            ),
            if (widget.index != null)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      iconColor: Colors.deepPurple,
                      icon: const Icon(
                        Icons.crisis_alert,
                        size: 70,
                      ),
                      title: const Text('¿Estás seguro?'),
                      content: const Text(
                          '¿Estas seguro que deseas eliminar esta tarea?\nSi la eliminas no podras recuperarla, tendras que volverla a crear'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar')),
                        FilledButton(
                            onPressed: () => _deleteTask(context),
                            child: const Text('Aceptar')),
                      ],
                    ),
                  );
                },
                child: const Text('Eliminar'),
              ),
          ],
        ),
      ),
    );
  }

  void _saveTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (_controller.text.isNotEmpty) {
      if (widget.index == null) {
        taskProvider.addTask(_controller.text, _descriptionController.text);
      } else {
        taskProvider.editTask(
            widget.index!, _controller.text, _descriptionController.text);
      }
      Navigator.pop(context);
    }
  }

  void _deleteTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (widget.index != null) {
      taskProvider.deleteTask(widget.index!);
      Navigator.pop(context);
    }
  }
}
