class Task {
  final int status, id;
  final String content;

  Task({required this.status, required this.id, required this.content});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      status: map['status'],
      id: map['id'],
      content: map['content'],
    );
  }
}
