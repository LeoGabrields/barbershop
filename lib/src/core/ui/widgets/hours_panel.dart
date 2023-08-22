import 'package:flutter/material.dart';

import '../constants.dart';

class HoursPanel extends StatelessWidget {
  final int startTime;
  final int endTime;
  final ValueChanged<int> onPressed;
  final List<int>? enableTimes;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onPressed,
    this.enableTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = startTime; i <= endTime; i++)
              TimerButton(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                onPressed: onPressed,
                enableTimes: enableTimes,
              ),
          ],
        )
      ],
    );
  }
}

class TimerButton extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final List<int>? enableTimes;

  const TimerButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.enableTimes,
  });

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final TimerButton(:label, :enableTimes, :onPressed, :value) = widget;

    final disableTime = enableTimes != null && !enableTimes.contains(value);

    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime
          ? null
          : () {
              setState(() {
                selected = !selected;
                onPressed(value);
              });
            },
      child: Container(
        width: 64,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor,
          border: Border.all(
            color: buttonBorderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
