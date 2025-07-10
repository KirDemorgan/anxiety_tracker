import 'package:flutter/material.dart';
import '../../../../data/models/note.dart';

// Виджет для отображения одного элемента заметки в списке.
class NoteItemWidget extends StatelessWidget {
  final Note note;

  const NoteItemWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final timeFormatter = MaterialLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.blueGrey[50],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Icon(Icons.article_outlined, color: Theme.of(context).primaryColor),
        title: Text(
          note.text,
          style: const TextStyle(fontSize: 15.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Время: ${timeFormatter.formatTimeOfDay(note.time, alwaysUse24HourFormat: true)}',
          style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
        ),
        // Можно добавить кнопку для удаления или редактирования, если потребуется
        // trailing: IconButton(icon: Icon(Icons.edit), onPressed: () { /* TODO: Edit note */ }),
      ),
    );
  }
}

