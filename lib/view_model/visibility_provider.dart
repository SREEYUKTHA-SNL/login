import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier {
  bool isObscured = true;

  void toggleVisibility() {
    isObscured = !isObscured;
    notifyListeners();
  }
}
