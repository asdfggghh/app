import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> _userTaskColl(String uid) =>
      _db.collection('users').doc(uid).collection('tasks');

  Stream<List<TaskModel>> taskStream(String uid) {
    return _userTaskColl(uid).orderBy('createdAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((d) => TaskModel.fromMap(d.data(), d.id)).toList();
    });
  }

  Future<void> addTask(String uid, TaskModel task) async {
    final id = task.id.isEmpty ? _uuid.v4() : task.id;
    final doc = _userTaskColl(uid).doc(id);
    await doc.set(task.toMap());
  }

  Future<void> updateTask(String uid, TaskModel task) async {
    final doc = _userTaskColl(uid).doc(task.id);
    task.updatedAt = DateTime.now();
    await doc.update(task.toMap());
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _userTaskColl(uid).doc(taskId).delete();
  }
}
