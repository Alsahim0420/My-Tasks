import 'package:flutter/material.dart';
import 'package:my_task/models/models.dart';
import 'package:my_task/providers/providers.dart';
import 'package:my_task/screens/screens.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedFilter = 'Todas'; // 'Todas', 'Completadas', 'Incompletas'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Task's"),
        actions: [
          // Botón de filtro
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (String value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Todas',
                child: Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: _selectedFilter == 'Todas'
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Todas las tareas',
                      style: TextStyle(
                        color: _selectedFilter == 'Todas'
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        fontWeight: _selectedFilter == 'Todas'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Completadas',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _selectedFilter == 'Completadas'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tareas completadas',
                      style: TextStyle(
                        color: _selectedFilter == 'Completadas'
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: _selectedFilter == 'Completadas'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Incompletas',
                child: Row(
                  children: [
                    Icon(
                      Icons.pending,
                      color: _selectedFilter == 'Incompletas'
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tareas incompletas',
                      style: TextStyle(
                        color: _selectedFilter == 'Incompletas'
                            ? Colors.orange
                            : Colors.grey,
                        fontWeight: _selectedFilter == 'Incompletas'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Botón de tema
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          // Aplicar filtro
          List<Task> filteredTasks = _getFilteredTasks(taskProvider.tasks);

          return Column(
            children: [
              // Indicador del filtro seleccionado
              if (_selectedFilter != 'Todas')
                Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getFilterColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getFilterColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFilterIcon(),
                        color: _getFilterColor(),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mostrando: $_selectedFilter',
                        style: TextStyle(
                          color: _getFilterColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              // Lista de tareas
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          Task task = filteredTasks[index];
                          // Encontrar el índice real en la lista original
                          int realIndex = taskProvider.tasks.indexOf(task);
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  taskProvider.toggleTaskCompletion(realIndex);
                                },
                              ),
                              title: Text(task.title),
                              subtitle: Text(
                                task.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: task.isCompleted
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                ),
                                child: Text(
                                  task.isCompleted
                                      ? "Completada"
                                      : "Incompleta",
                                  style: TextStyle(
                                    color: task.isCompleted
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                  ),
                                ),
                              ),
                              onTap: () {
                                _navigateToTaskDetailScreen(context, realIndex);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTaskDetailScreen(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Método para filtrar tareas
  List<Task> _getFilteredTasks(List<Task> tasks) {
    switch (_selectedFilter) {
      case 'Completadas':
        return tasks.where((task) => task.isCompleted).toList();
      case 'Incompletas':
        return tasks.where((task) => !task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  // Método para obtener el color del filtro
  Color _getFilterColor() {
    switch (_selectedFilter) {
      case 'Completadas':
        return Colors.green;
      case 'Incompletas':
        return Colors.orange;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  // Método para obtener el icono del filtro
  IconData _getFilterIcon() {
    switch (_selectedFilter) {
      case 'Completadas':
        return Icons.check_circle;
      case 'Incompletas':
        return Icons.pending;
      default:
        return Icons.list;
    }
  }

  // Método para mostrar estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFilterIcon(),
            size: 80,
            color: _getFilterColor().withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.color
                  ?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubtitle(),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Método para obtener mensaje de estado vacío
  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'Completadas':
        return 'No hay tareas completadas';
      case 'Incompletas':
        return 'No hay tareas pendientes';
      default:
        return 'No hay tareas';
    }
  }

  // Método para obtener subtítulo de estado vacío
  String _getEmptyStateSubtitle() {
    switch (_selectedFilter) {
      case 'Completadas':
        return 'Completa algunas tareas para verlas aquí';
      case 'Incompletas':
        return 'Todas las tareas están completadas';
      default:
        return 'Agrega tu primera tarea tocando el botón +';
    }
  }

  void _navigateToTaskDetailScreen(BuildContext context, int? index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(index: index),
      ),
    );
  }
}
