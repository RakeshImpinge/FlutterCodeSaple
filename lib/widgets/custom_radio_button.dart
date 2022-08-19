import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';

class MyRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final String text;
  final BuildContext context;
  final ValueChanged<T?> onChanged;

  const MyRadioOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.text,
    required this.context,
    required this.onChanged,
  });

  Widget _buildLabel() {
    final bool isSelected = value == groupValue;

    return Container(
      width: 17,
      height: 17,
      decoration: ShapeDecoration(
        shape: const CircleBorder(
          side: BorderSide(
            width: 3,
            color: AppThemes.lightGreyTextColor,
          ),
        ),
        color: isSelected
            ? AppThemes.lightGreyTextColor
            : Theme.of(context).primaryColorDark,
      ),
      child: Center(
        child: Text(
          '',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () => onChanged(value),
        splashColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLabel(),
            _buildText(),
          ],
        ),
      ),
    );
  }
}
