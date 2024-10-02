// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../model/task_model.dart';
//
//
// class Summary extends StatefulWidget {
//   const Summary({super.key});
//
//   @override
//   State<Summary> createState() => _SummaryState();
// }
//
// class _SummaryState extends State<Summary> {
//   DateTime _selectedDay = DateTime.now();
//   TaskPriority _selectedPriority = TaskPriority.mid;
//
//   // Define colors for priorities
//   final Map<TaskPriority, Color> _priorityColors = {
//     TaskPriority.high: Colors.red,
//     TaskPriority.mid: Colors.yellow,
//     TaskPriority.low: Colors.green,
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: TableCalendar(
//                   focusedDay: _selectedDay,
//                   firstDay: DateTime.utc(2000, 1, 1),
//                   lastDay: DateTime.utc(2030, 12, 31),
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                     });
//                     _showTasksForDate(context, selectedDay);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Filter by Priority:'),
//                     Row(
//                       children: TaskPriority.values.map((priority) {
//                         return Radio<TaskPriority>(
//                           value: priority,
//                           groupValue: _selectedPriority,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedPriority = value!;
//                             });
//                             Provider.of<TaskProvider>(context, listen: false)
//                                 .setPriorityFilter(_selectedPriority);
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//               MaterialButton(
//                 onPressed: () => _showAddTaskDialog(context),
//                 child: const Text('Add new task'),
//               ),
//             ],
//           ),
//       ),
//     );
//   }
//
//   // Show tasks in a dialog and add task-saving mechanism using Hive
//   void _showAddTaskDialog(BuildContext context) {
//     String newTask = '';
//     TaskPriority selectedPriority = TaskPriority.mid;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add new Task'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 onChanged: (value) {
//                   newTask = value;
//                 },
//                 decoration: const InputDecoration(hintText: 'Enter task name'),
//               ),
//               const SizedBox(height: 16.0),
//               const Text('Select Priority:'),
//               Column(
//                 children: TaskPriority.values.map((priority) {
//                   return RadioListTile<TaskPriority>(
//                     value: priority,
//                     groupValue: selectedPriority,
//                     title: Text(priority.toString().split('.').last),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedPriority = value!;
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (newTask.isNotEmpty) {
//                   Provider.of<TaskProvider>(context, listen: false)
//                       .addTask(newTask, _selectedDay, selectedPriority);
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   void _showTaskDetailsDialog(BuildContext context, List<Task> tasks) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Tasks for Selected Date'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return ListTile(
//                   title: Text(
//                     task.title,
//                     style: TextStyle(
//                       color: _priorityColors[task.priority],
//                       decoration: task.isCompleted
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                     ),
//                   ),
//                   subtitle: Text('Priority: ${task.priority.toString().split('.').last}'),
//                   trailing: Checkbox(
//                     value: task.isCompleted,
//                     onChanged: (value) {
//                       Provider.of<TaskProvider>(context, listen: false)
//                           .toggleTaskCompletion(tasks.indexOf(task) as Task);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showTasksForDate(BuildContext context, DateTime date) {
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//     final tasks = taskProvider.taskForDate(date);
//     if (tasks.isNotEmpty) {
//       _showTaskDetailsDialog(context, tasks);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No tasks for this date')),
//       );
//     }
//   }
// }

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:timily/app/provider/auth_provider.dart';

import '../../provider/event_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Schedule an Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthenticationProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: eventsProvider.selectedDate,
            onDaySelected: (selectedDay, focusedDay) {
              eventsProvider.setSelectedDate(selectedDay);
              _showEventDialog(context);
            },
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     _showEventDialog(context);
          //   },
          //   child: Text("Add Event"),
          // ),
          // Display events for the selected day
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: eventsProvider.getEventsForDay(eventsProvider.selectedDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text('Priority: ${event.priority}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDialog(BuildContext context) {
    final eventsProvider = Provider.of<EventProvider>(context, listen: false);
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(hintText: "Enter Event"),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Priority:"),
                ListTile(
                  title: const Text('Low'),
                  leading: Radio<String>(
                    value: 'Low',
                    groupValue: eventsProvider.selectedPriority,
                    onChanged: (String? value) {
                      eventsProvider.setSelectedPriority(value!);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Medium'),
                  leading: Radio<String>(
                    value: 'Medium',
                    groupValue: eventsProvider.selectedPriority,
                    onChanged: (String? value) {
                      eventsProvider.setSelectedPriority(value!);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('High'),
                  leading: Radio<String>(
                    value: 'High',
                    groupValue: eventsProvider.selectedPriority,
                    onChanged: (String? value) {
                      eventsProvider.setSelectedPriority(value!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                eventsProvider.saveEvent(_eventController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
