import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      _tasks = taskList.map((taskJson) {
        // Convertir la cadena JSON a un mapa antes de llamar a Task.fromJson
        Map<String, dynamic> taskMap = json.decode(taskJson);
        return Task.fromJson(taskMap);
      }).toList();
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convertir cada tarea a su representación JSON antes de almacenarlo en la lista
    List<String> taskList =
        _tasks.map((task) => json.encode(task.toJson())).toList();

    prefs.setStringList('tasks', taskList);
  }

  void addTask(String title, String description) {
    _tasks.add(Task(title: title, description: description));
    saveTasks();
    notifyListeners();
  }

  void editTask(int index, String title, String description) {
    _tasks[index].title = title;
    _tasks[index].description = description;
    saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }
}
