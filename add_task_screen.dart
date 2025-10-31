import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';

class AddTaskScreen extends StatefulWidget {
  final String uid;
  AddTaskScreen({required this.uid});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String _category = 'General';
  String _priority = 'Medium';
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _title, decoration: InputDecoration(labelText: 'Title')),
          TextField(controller: _desc, decoration: InputDecoration(labelText: 'Description')),
          DropdownButton<String>(
            value: _category,
            items: ['General','Work','Study','Personal','Shopping'].map((c) => DropdownMenuItem(child: Text(c), value: c)).toList(),
            onChanged: (v) => setState(() => _category = v ?? 'General'),
          ),
          DropdownButton<String>(
            value: _priority,
            items: ['High','Medium','Low'].map((c) => DropdownMenuItem(child: Text(c), value: c)).toList(),
            onChanged: (v) => setState(() => _priority = v ?? 'Medium'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(_dueDate == null ? 'No due date' : 'Due: ${_dueDate.toString()}'),
              Spacer(),
              TextButton(
                child: Text('Pick Date'),
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 365)), lastDate: DateTime.now().add(Duration(days: 3650)));
                  if (d != null) {
                    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    setState(() {
                      _dueDate = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0);
                    });
                  }
                },
              )
            ],
          ),
          Spacer(),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () async {
              final newTask = TaskModel(
                id: '',
                title: _title.text.trim(),
                description: _desc.text.trim(),
                category: _category,
                priority: _priority,
                dueDate: _dueDate,
              );
              await firestore.addTask(widget.uid, newTask);
              Navigator.of(context).pop();
            },
          )
        ]),
      ),
    );
  }
}
