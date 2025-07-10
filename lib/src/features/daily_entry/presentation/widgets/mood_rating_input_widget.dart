import 'package:flutter/material.dart';

class MoodRatingInputWidget extends StatelessWidget {
  final String label;
  final double? value;
  final ValueChanged<double> onChanged;

  const MoodRatingInputWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = value ?? 5.0;

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
          value: currentValue,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: value != null ? value!.round().toString() : currentValue.round().toString(),
          onChanged: onChanged,
          activeColor: _getSliderColor(value ?? 5.0),
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

