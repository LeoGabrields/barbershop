import 'package:flutter/material.dart';

import '../constants.dart';

class WeekDaysPanel extends StatelessWidget {
  final ValueChanged<String> onDayPressed;
  const WeekDaysPanel({super.key, required this.onDayPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(label: 'Seg', onDayPressed: onDayPressed),
                ButtonDay(label: 'Ter', onDayPressed: onDayPressed),
                ButtonDay(label: 'Qua', onDayPressed: onDayPressed),
                ButtonDay(label: 'Qui', onDayPressed: onDayPressed),
                ButtonDay(label: 'Sex', onDayPressed: onDayPressed),
                ButtonDay(label: 'Sab', onDayPressed: onDayPressed),
                ButtonDay(label: 'Dom', onDayPressed: onDayPressed),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDayPressed;
  const ButtonDay({
    required this.label,
    required this.onDayPressed,
    super.key,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          widget.onDayPressed(widget.label);
          setState(() {
            selected = !selected;
          });
        },
        child: Container(
          width: 40,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: buttonColor,
              border: Border.all(
                color: buttonBorderColor,
              )),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
