import 'package:flutter/material.dart';

extension UnfocusExtension on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();
}
