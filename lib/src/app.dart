import 'package:flutter/material.dart';
import 'features/daily_entry/presentation/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Корневой виджет приложения.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Отслеживание тревожности',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Пример более минималистичного стиля для компонентов форм
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.teal, // Использует primarySwatch по умолчанию
            // foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        // Стиль для карточек, можно использовать для обрамления секций
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      home: const HomeScreen(),
      // Для использования TimeOfDay.format(context) и других локализованных данных:
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'), // Добавьте поддержку русского языка
        // Locale('en', 'US'), // и других языков при необходимости
      ],
      locale: const Locale('ru', 'RU'), // Установка русской локали по умолчанию
      debugShowCheckedModeBanner: false,
    );
  }
}

