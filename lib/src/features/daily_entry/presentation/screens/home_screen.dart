import 'package:flutter/material.dart';
import '../widgets/daily_log_view_widget.dart';
import '../../../summary/presentation/screens/summary_screen.dart';

// Главный экран приложения с навигацией.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Индекс выбранной вкладки

  // Список виджетов для каждой вкладки
  static final List<Widget> _widgetOptions = <Widget>[
    const DailyLogViewWidget(),
    const SummaryScreen(),
  ];

  // Обработчик нажатия на элемент BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar может быть разным для каждой вкладки, если обернуть _widgetOptions[ _selectedIndex] в свой Scaffold,
      // либо общий AppBar здесь. Для простоты пока без AppBar здесь, каждая вкладка может иметь свой.
      body: IndexedStack( // IndexedStack сохраняет состояние страниц при переключении
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Дневник',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Сводка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Цвет активной вкладки
        onTap: _onItemTapped,
      ),
    );
  }
}

