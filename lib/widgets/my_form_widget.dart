import 'package:flutter/material.dart';
import 'package:semana9_taskdb/db/db_admin.dart';
import 'package:semana9_taskdb/models/task_model.dart';

class MyFormWidget extends StatefulWidget {
  TaskModel? task;
  MyFormWidget({super.key, this.task});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String dropdownValue = 'Pendiente';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      titleController = TextEditingController(text: widget.task!.title);
      descriptionController =
          TextEditingController(text: widget.task!.description);
      dropdownValue = widget.task!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar tarea'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Titulo',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un titulo';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripcion',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripcion';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                const Text("Estado: "),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Pendiente', 'En proceso', 'Terminado']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              TaskModel task = TaskModel(
                title: titleController.text,
                description: descriptionController.text,
                status: dropdownValue,
              );
              if (widget.task == null) {
                DBAdmin.db.insertTask(task).then(
                      (value) => {
                        if (value > 0)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Tarea agregada'),
                                  ],
                                ),
                              ),
                            ),
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  children: [
                                    Icon(Icons.error),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Error al agregar tarea'),
                                  ],
                                ),
                              ),
                            ),
                          }
                      },
                    );
                Navigator.pop(context);
              } else {
                task.id = widget.task!.id;
                DBAdmin.db.updateTask(task).then(
                      (value) => {
                        if (value > 0)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Tarea actualizada'),
                                  ],
                                ),
                              ),
                            ),
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  children: [
                                    Icon(Icons.error),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Error al actualizar tarea'),
                                  ],
                                ),
                              ),
                            ),
                          }
                      },
                    );
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
