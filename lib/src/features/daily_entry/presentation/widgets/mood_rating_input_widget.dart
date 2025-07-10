import 'package:flutter/material.dart';

// Виджет для ввода одной оценки настроения (например, слайдер).
class MoodRatingInputWidget extends StatelessWidget {
  final String label;
  final double? value; // Может быть null, если еще не установлено
  final ValueChanged<double> onChanged;

  const MoodRatingInputWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Если value is null, устанавливаем дефолтное значение для слайдера (например, середина)
    // или позволяем слайдеру быть в "неопределенном" состоянии, если дизайн это поддерживает.
    // Для простоты, если null, можно считать как 5.0 для отображения, но не передавать в onChanged, пока пользователь не двинет.
    // Либо, как сейчас, value может быть null, и слайдер будет это отражать (или вызовет ошибку, если min/max/value несовместимы).
    // Slider требует, чтобы value было в диапазоне min-max. Если value null, нужно задать начальное.
    // Установим 5.0 как начальное значение, если value is null.
    final currentValue = value ?? 5.0; // Отображаемое значение, если не задано

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            Text(
              value != null ? '${value!.round()}/10' : 'Не оценено',
              style: TextStyle(fontSize: 16.0, color: value != null ? Theme.of(context).primaryColor : Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: currentValue, // Используем currentValue для ползунка
          min: 1.0,
          max: 10.0,
          divisions: 9, // 10-1 = 9 отрезков (10 возможных значений)
          label: value != null ? value!.round().toString() : currentValue.round().toString(), // Всплывающая подсказка
          onChanged: onChanged, // onChanged будет вызван с новым значением
          activeColor: _getSliderColor(value ?? 5.0), // Цвет зависит от фактического value или дефолта
          inactiveColor: _getSliderColor(value ?? 5.0).withOpacity(0.3),
        ),
      ],
    );
  }

  Color _getSliderColor(double mood) {
    if (mood <= 3) return Colors.red.shade400;
    if (mood <= 7) return Colors.orange.shade400;
    return Colors.green.shade400;
  }
}

