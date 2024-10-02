
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
enum TaskPriority {
  @HiveField(0)
  high,
  @HiveField(1)
  mid,
  @HiveField(2)
  low
}

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  bool isCompleted;
  @HiveField(3)
  TaskPriority priority;

  Task({
    required this.title,
    required this.date,
    this.isCompleted = false,
    this.priority = TaskPriority.mid
  });
}