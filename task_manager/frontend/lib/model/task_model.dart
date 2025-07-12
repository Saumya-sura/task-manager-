import 'dart:convert';
import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String hexColor;
  final String uid;
  final DateTime dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.hexColor,
    required this.uid,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hexColor': hexColor,
      'uid': uid,
      'dueAt': dueAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    try {
      return TaskModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        hexColor: map['hexColor'] ?? '#FFFFFF',
        uid: map['uid'] ?? '',
        dueAt: map['dueAt'] != null ? DateTime.parse(map['dueAt']) : DateTime.now(),
        createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
        updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing TaskModel: $e');
      print('Map data: $map');
      // Return a default task model in case of error
      return TaskModel(
        id: 'error',
        title: 'Error loading task',
        description: 'There was an error loading this task',
        hexColor: '#FF0000',
        uid: '',
        dueAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) {
    try {
      return TaskModel.fromMap(json.decode(source));
    } catch (e) {
      print('Error parsing TaskModel from JSON: $e');
      // Return a default task model in case of error
      return TaskModel(
        id: 'error',
        title: 'Error loading task',
        description: 'There was an error loading this task',
        hexColor: '#FF0000',
        uid: '',
        dueAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Color get color {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
