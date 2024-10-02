import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timily/demo/utils.dart';

import 'event.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TestingApp());
}

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // store the events created

  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(AppUtils.getEventsForDay(_selectedDay!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if(!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = AppUtils.getEventsForDay(_selectedDay!);
      });
      showPastPlans();
    } else if(isSameDay(_selectedDay, selectedDay)) {
      showPastPlans();
    }
    createTaskDialog(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            '${_focusedDay.year}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: const Color(0xFF2809E3)
          ),
        ),
        backgroundColor: const Color(0xFFE1DEF0),
      ),
      body: Column(
        children: [
          TableCalendar(
              firstDay: DateTime.utc(2010, 3, 1),
              lastDay: DateTime.utc(2030, 3, 14),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            focusedDay: _focusedDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: AppUtils.getEventsForDay,
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false
            ),
            onFormatChanged: (format) {
                if(_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
            },
            onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text('${AppUtils.returnDay(_focusedDay)} tasks'),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () => print(""),
                            title: Text(value[index].title),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPastPlans,
        shape: StadiumBorder(),
        child: Text('tasks'),
      ),
    );
  }

  void createTaskDialog(BuildContext context) {
    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title:Text('${AppUtils.returnDay(_focusedDay)} ${AppUtils.returnMonth(_focusedDay)} plans'),
            content: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _eventController,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    //store the event name into the map
                    AppUtils.events.addAll({
                      _selectedDay!: [Event(_eventController.text)]
                    });
                    Navigator.pop(context);
                    _selectedEvents.value = AppUtils.getEventsForDay(_selectedDay!);
                  },
                  child: const Text('Submit')
              )
            ],
          );
        });
  }

  // void showTaskForSelectedDate() {
  //   showDialog(context: context, builder: (context) {
  //     return AlertDialog(
  //       title: Text('${AppUtils.returnDay(_focusedDay)} tasks'),
  //       content:
  //     );
  //   });
  // }

  void showPastPlans() {
    showDialog(context: context,
        builder: (context) {
      return AlertDialog(
        title: Text('Past Event Day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No event can be scheduled for this day'),
            Row(
              children: [
                MaterialButton(
                    onPressed: () {},
                  height: 30,
                  minWidth: 30,
                  shape: const StadiumBorder(),
                  color: const Color(0xFF25E805).withOpacity(1),
                ),
                const Text('For a successful day')
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  height: 30,
                  minWidth: 30,
                  shape: const StadiumBorder(),
                  color: const Color(0xFFFFBF1A),
                ),
                const Text('For a progressive day')
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  height: 30,
                  minWidth: 30,
                  shape: const StadiumBorder(),
                  color: const Color(0xFFCCC6F1),
                ),
                const Text('For a normal day')
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  height: 30,
                  minWidth: 30,
                  shape: const StadiumBorder(),
                  color: const Color(0xFFFF470D),
                ),
                const Text('Tasks not completed')
              ],
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              color: Colors.blue,
              child: Text('Done'),
            )
          ],
        ),
      );
        });
  }
}