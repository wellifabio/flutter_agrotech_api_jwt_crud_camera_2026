import 'package:flutter/material.dart';

import '/ui/login.dart';
import '/ui/style/theme.dart';

void main() {
  runApp(
    MaterialApp(title: "AgroTech", theme: AppTheme.appTheme, home: Login()),
  );
}
