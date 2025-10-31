import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/voice_service.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool listening = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final uid = auth.currentUser?.uid;
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    final voice = Provider.of<VoiceService>(context, listen: false);

    if (uid == null) return Scaffold(body: Center(child: Text('User not logged in')));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () async => await auth.signOut()),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: firestore.taskStream(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final tasks = snapshot.data!;
          if (tasks.isEmpty) return Center(child: Text('No tasks yet'));
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final t = tasks[i];
              return ListTile(
                title: Text(t.title, style: TextStyle(decoration: t.isCompleted ? TextDecoration.lineThrough : null)),
                subtitle: Text(t.category + (t.dueDate != null ? ' • due ${t.dueDate}' : '')),
                trailing: Checkbox(
                  value: t.isCompleted,
                  onChanged: (v) {
                    t.isCompleted = v ?? false;
                    firestore.updateTask(uid, t);
                  },
                ),
                onTap: () {
                  // open task detail / edit
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'voice',
            child: Icon(listening ? Icons.mic : Icons.mic_none),
            onPressed: () async {
              if (!listening) {
                final ok = await voice.init();
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speech unavailable')));
                  return;
                }
                setState(() => listening = true);
                voice.startListening((recognizedText) async {
                  // Simple parser: treat whole recognized text as task title
                  final newTask = TaskModel(
                    id: '',
                    title: recognizedText,
                    description: null,
                    category: 'General',
                    priority: 'Medium',
                  );
                  await firestore.addTask(uid, newTask);
                  voice.stop();
                  setState(() => listening = false);
                });
              } else {
                voice.stop();
                setState(() => listening = false);
              }
            },
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            child: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddTaskScreen(uid: uid))),
          ),
        ],
      ),
    );
  }
}
