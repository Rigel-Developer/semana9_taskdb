import 'package:flutter/material.dart';
import 'package:semana9_taskdb/db/db_admin.dart';
import 'package:semana9_taskdb/models/task_model.dart';
import 'package:semana9_taskdb/widgets/my_form_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  showDialogForm(TaskModel? task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyFormWidget(
          task: task,
        );
      },
    ).then(
      (value) => {
        setState(() {}),
      },
    );
  }

  deleteTask(int id) {
    DBAdmin.db.deleteTask(id).then((value) => {
          if (value > 0)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    children: [
                      Icon(Icons.check),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Tarea eliminada'),
                    ],
                  ),
                ),
              ),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogForm(null);
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: DBAdmin.db.getTasks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<TaskModel> taskList = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  secondaryBackground: Container(
                    color: Colors.yellow,
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    return true;
                  },
                  onDismissed: (DismissDirection direction) {
                    deleteTask(taskList[index].id!);
                  },

                  // direction: DismissDirection.endToStart,
                  child: Container(
                    color: taskList[index].status == 'Pendiente'
                        ? Colors.red
                        : taskList[index].status == 'En proceso'
                            ? Colors.orange
                            : Colors.green,
                    child: ListTile(
                      title: Text(taskList[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(taskList[index].description),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          showDialogForm(taskList[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
