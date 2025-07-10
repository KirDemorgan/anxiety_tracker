import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Необходимо добавить зависимость table_calendar в pubspec.yaml

// Виджет календаря.
// Предполагается использование пакета table_calendar.
class CalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const CalendarWidget({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          locale: 'ru_RU', // Установка русской локали для календаря
          firstDay: DateTime.utc(2020, 1, 1), // Начальная доступная дата
          lastDay: DateTime.utc(2030, 12, 31), // Конечная доступная дата
          focusedDay: focusedDay,
          selectedDayPredicate: (day) {
            // Определяет, какой день считается выбранным
            return isSameDay(selectedDay, day);
          },
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
          calendarFormat: CalendarFormat.month, // Формат календаря (неделя, 2 недели, месяц)
          startingDayOfWeek: StartingDayOfWeek.monday, // Начало недели с понедельника
          calendarStyle: CalendarStyle(
            // Стиль для выбранного дня
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            // Стиль для сегодняшнего дня
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            // Стиль для дней вне текущего месяца
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false, // Скрыть кнопку изменения формата
            titleCentered: true,
            titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.grey),
            rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

