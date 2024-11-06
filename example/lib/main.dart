import 'package:flutter/material.dart';
import 'package:flutter_weekly_calendar/weekly_calendar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _currentMonth = '';
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Weekly Calendar'),
        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            Text(_currentMonth),
            WeeklyCalendarWidget(
              totalPastDays: 60,
              totalFutureDays: 60,
              onDateSelected: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate.toString();
                });
              },
              onWeekChange: (month, date){
                setState(() {
                  _currentMonth = month;
                });
              },
            ),
            Center(child: Text(_selectedDate)),
          ],
        ),
      ),
    );
  }
}
