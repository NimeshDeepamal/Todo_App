import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../datasources/local_db.dart';
import '../models/task_dto.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final _firestore = FirebaseFirestore.instance;

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    return user.uid;
  }

  CollectionReference get _taskCollection => _firestore.collection('tasks');

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final snapshot = await _taskCollection.where('userId', isEqualTo: _userId).get();

      for (var doc in snapshot.docs) {
        final dto = TaskDto.fromMap(doc.data() as Map<String, dynamic>);
        if (dto.userId == _userId) {
          await LocalDb.insertTask(dto);
        }
      }

      final tasks = await LocalDb.getAllTasks(_userId);
      return tasks.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      debugPrint("getAllTasks failed: $e");
      return [];
    }
  }

  @override
  Future<void> addTask(Task task) async {
    final dto = TaskDto.fromEntity(task);
    if (dto.userId == _userId) {
      await LocalDb.insertTask(dto);
    }
    await _taskCollection.doc(task.id).set(dto.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    final dto = TaskDto.fromEntity(task);
    await LocalDb.updateTask(dto);
    await _taskCollection.doc(task.id).update(dto.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await LocalDb.deleteTask(id, _userId);
    await _taskCollection.doc(id).delete();
  }
}
