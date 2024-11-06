# Weekly Calendar Widget

A simple and lightweight weekly calendar view with extensive customization options.

## Preview:
![prev](https://github.com/IdealITTechno/flutter_weekly_calendar/blob/main/media/prev.gif)

## Installation

```yaml
  dependencies:
    flutter:
      sdk: flutter

    flutter_reels_viewer: ^1.0.0
```

## Usage

```Dart
import 'package:flutter_weekly_calendar/weekly_calendar_widget.dart';
```

```Dart
WeeklyCalendarWidget(
   totalPastDays: 60,
   totalFutureDays: 60,
   onDateSelected: (selectedDate) {
      print("Selected Date: $selectedDate");
   },
),
```