
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyCalendarWidget extends StatefulWidget {
  final int totalPastDays;
  final int totalFutureDays;
  final DateTime? selectedDate;
  final double height;
  final void Function(DateTime selectedDate)? onDateSelected;
  final void Function(String month, DateTime firstDayOfWeek)? onWeekChange;

   WeeklyCalendarWidget({
    required this.totalPastDays,
    required this.totalFutureDays,
    this.onDateSelected,
    this.onWeekChange,
    this.selectedDate,
    this.height = 100,
  });

  @override
  _WeeklyCalendarWidgetState createState() => _WeeklyCalendarWidgetState();
}

class _WeeklyCalendarWidgetState extends State<WeeklyCalendarWidget> {

  late PageController _pageController;
  List<WeekItem> _weeks = [];
  DateTime _selectedDteTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      _initCalendar();
    });

  }

  _initCalendar() async {
    var minDate = DateTime.now().add( Duration(days: -widget.totalPastDays));
    var maxDate = DateTime.now().add( Duration(days: widget.totalFutureDays));
    _weeks = await _generateWeeks(minDate, maxDate);
    int currentWeekIndex = _indexOfCurrentWeek();
    _pageController = PageController(initialPage: widget.selectedDate == null
        ? currentWeekIndex : _indexOfTheDate(widget.selectedDate));

    widget.onWeekChange?.call(_weeks[currentWeekIndex].month, _weeks[currentWeekIndex].daysOfWeek.first);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          widget.onWeekChange?.call(_weeks[index].month, _weeks[index].daysOfWeek.first);
        },
        itemBuilder: (context, index) {
          return _buildWeekView(_weeks[index]);
        },
        itemCount: _weeks.length, // Limit to past and future weeks
      ),
    );
  }

  // Function to build the weekly view based on the start of the week
  Widget _buildWeekView(WeekItem weekItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        DateTime day = weekItem.daysOfWeek[index];
        bool isToday = day.day == DateTime.now().day &&
            day.month == DateTime.now().month &&
            day.year == DateTime.now().year;
        bool isSelectedDteTime = day.day == _selectedDteTime.day &&
            day.month == _selectedDteTime.month &&
            day.year == _selectedDteTime.year;

        return GestureDetector(
          onTap: () {
            widget.onDateSelected?.call(day);
            setState(() {
              _selectedDteTime = day;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day of the week
              Text(
                DateFormat('EEE').format(day),
                style: TextStyle(
                  fontSize: 14,
                  color: isToday ? Colors.red : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              // Day number with circular background
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: isSelectedDteTime? Colors.blueAccent : Colors.transparent)
                ),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: isToday ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  int _indexOfCurrentWeek() {
    DateTime today = DateTime.now();

    for (int i = 0; i < _weeks.length; i++) {
      WeekItem week = _weeks[i];

      // Check if today's date is in the current week's daysOfWeek
      if (week.daysOfWeek.any((day) =>
      day.year == today.year && day.month == today.month && day.day == today.day)) {
        return i;
      }
    }

    // Return 0 if no matching week found
    return 0;
  }

  int _indexOfTheDate(DateTime? dateTime) {
    if (dateTime == null) return 0;

    for (int i = 0; i < _weeks.length; i++) {
      WeekItem week = _weeks[i];

      // Check if today's date is in the current week's daysOfWeek
      if (week.daysOfWeek.any((day) =>
      day.year == dateTime.year && day.month == dateTime.month && day.day == dateTime.day)) {
        return i;
      }
    }

    // Return 0 if no matching week found
    return 0;
  }


  Future<List<WeekItem>> _generateWeeks(DateTime minDateTime, DateTime maxDateTime) async{
    // Logic to fill gap of week days, means reset minDate to Mon and maxDate to Sun
    var minDate = minDateTime.add(Duration(days: -(minDateTime.weekday-1)));
    var maxDate = maxDateTime.add(Duration(days: (7-maxDateTime.weekday)));
    List<WeekItem> weeks = [];
    DateTime current = minDate;
    DateFormat monthFormat = DateFormat('MMMM');

    while (current.isBefore(maxDate)) {
      List<DateTime> daysOfWeek = [];
      DateTime weekStart = current;

      // Populate the week days
      for (int i = 0; i < 7; i++) {
        if (weekStart.isAfter(maxDate)) break;
        daysOfWeek.add(weekStart);
        weekStart = weekStart.add(const Duration(days: 1));
      }

      // Add a new week to the list with the month name and days
      weeks.add(WeekItem(monthFormat.format(current), daysOfWeek));

      // Move to the next week
      current = current.add(const Duration(days: 7));
    }

    return weeks;
  }


}

class WeekItem {
  final String month;
  final List<DateTime> daysOfWeek;

  WeekItem(this.month, this.daysOfWeek);
}