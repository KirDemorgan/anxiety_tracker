import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // For calendar localization

import 'src/app.dart';
import 'src/data/database/database_helper.dart';
import 'src/data/database/daos/daily_mood_entry_dao.dart';
import 'src/data/database/daos/note_dao.dart';
import 'src/data/database/daos/medication_dao.dart';
import 'src/features/daily_entry/data/repositories/daily_mood_entry_repository_impl.dart';
import 'src/features/daily_entry/data/repositories/note_repository_impl.dart';
import 'src/features/daily_entry/data/repositories/medication_repository_impl.dart';
import 'src/features/daily_entry/domain/repositories/daily_mood_entry_repository.dart';
import 'src/features/daily_entry/domain/repositories/note_repository.dart';
import 'src/features/daily_entry/domain/repositories/medication_repository.dart';
import 'src/features/daily_entry/presentation/providers/daily_data_provider.dart';

// Для корректной работы форматирования дат и времени, например, в TimeOfDay.format(context),
// и для table_calendar локализации, убедитесь, что в pubspec.yaml добавлены зависимости:
// dependencies:
//   flutter:
//     sdk: flutter
//   flutter_localizations:
//     sdk: flutter
//   intl: ^0.18.0 # или другая актуальная версия
//   table_calendar: ^3.0.0 # или актуальная версия
//   provider: ^6.0.0 # или актуальная версия
//   sqflite: ^2.0.0 # или актуальная версия
//   path_provider: ^2.0.0 # или актуальная версия
//   path: ^1.8.0 # sqflite usually depends on this, or add explicitly

Future<void> main() async {
  // Необходимо для вызова асинхронных операций перед runApp,
  // а также для инициализации локализации календаря.
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация локализации для дат (например, для table_calendar)
  await initializeDateFormatting('ru_RU', null);

  // Инициализация базы данных
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // Ensure DB is initialized

  // Создание DAO
  final dailyMoodEntryDao = DailyMoodEntryDao(dbHelper);
  final noteDao = NoteDao(dbHelper);
  final medicationDao = MedicationDao(dbHelper);

  // Создание репозиториев
  final dailyMoodEntryRepository = DailyMoodEntryRepositoryImpl(dailyMoodEntryDao);
  final noteRepository = NoteRepositoryImpl(noteDao);
  final medicationRepository = MedicationRepositoryImpl(medicationDao);

  runApp(
    MultiProvider(
      providers: [
        // Предоставляем экземпляры репозиториев, если они нужны напрямую где-то еще,
        // но обычно провайдеры состояния инкапсулируют их использование.
        Provider<DailyMoodEntryRepository>.value(value: dailyMoodEntryRepository),
        Provider<NoteRepository>.value(value: noteRepository),
        Provider<MedicationRepository>.value(value: medicationRepository),
        
        // Главный провайдер состояния для данных ежедневника
        ChangeNotifierProvider(
          create: (context) => DailyDataProvider(
            dailyMoodEntryRepository: dailyMoodEntryRepository,
            noteRepository: noteRepository,
            medicationRepository: medicationRepository,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
