class Event {
  int? id;
  bool? isCompleted;
  Priority? priority;
  String title;
  Event(this.title);
}

enum Priority {
  high,
  mid,
  low
}