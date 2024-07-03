import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/task.dart';
import 'package:flutter_sqflite/services/database_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _tasks;
  final DatabaseServices _services = DatabaseServices.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Add tasks"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _tasks = value;
                            });
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder()),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_tasks == null || _tasks == "") {
                              Navigator.pop(context);
                            } else {
                              _services.addTask(_tasks!);
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          color: Colors.black,
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Sqflite flutter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _services.getTasks(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Task task = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            _services.deleteTask(task.id);
                            setState(() {});
                          },
                          icon: Icon(Icons.delete)),
                      title: Text(task.content),
                      trailing: Checkbox(
                          value: task.status == 1,
                          onChanged: (value) {
                            _services.updateTask(
                                task.id, value == true ? 1 : 0);
                            setState(() {});
                          }),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
