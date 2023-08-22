import 'package:flutter/material.dart';

class BarbershopNavGlobalKey {
  static BarbershopNavGlobalKey? _instance;
  final navkey = GlobalKey<NavigatorState>();

  BarbershopNavGlobalKey._();

  static BarbershopNavGlobalKey get i =>
      _instance ??= BarbershopNavGlobalKey._();
}
