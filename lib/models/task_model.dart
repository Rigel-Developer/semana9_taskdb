class TaskModel {
  int? id;
  String title;
  String description;
  String status;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
      };
}
