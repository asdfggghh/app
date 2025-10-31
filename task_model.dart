import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String? description;
  String category;
  String priority; // 'High' / 'Medium' / 'Low'
  DateTime? dueDate;
  DateTime? reminderDate;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.category = 'General',
    this.priority = 'Medium',
    this.dueDate,
    this.reminderDate,
    this.isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'],
      category: map['category'] ?? 'General',
      priority: map['priority'] ?? 'Medium',
      dueDate: map['dueDate'] != null ? (map['dueDate'] as Timestamp).toDate() : null,
      reminderDate: map['reminderDate'] != null ? (map['reminderDate'] as Timestamp).toDate() : null,
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'reminderDate': reminderDate != null ? Timestamp.fromDate(reminderDate!) : null,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
