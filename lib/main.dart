import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  final dailyMoodEntryDao = DailyMoodEntryDao(dbHelper);
  final noteDao = NoteDao(dbHelper);
  final medicationDao = MedicationDao(dbHelper);

  final dailyMoodEntryRepository = DailyMoodEntryRepositoryImpl(dailyMoodEntryDao);
  final noteRepository = NoteRepositoryImpl(noteDao);
  final medicationRepository = MedicationRepositoryImpl(medicationDao);

  runApp(
    MultiProvider(
      providers: [
        Provider<DailyMoodEntryRepository>.value(value: dailyMoodEntryRepository),
        Provider<NoteRepository>.value(value: noteRepository),
        Provider<MedicationRepository>.value(value: medicationRepository),
        
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
