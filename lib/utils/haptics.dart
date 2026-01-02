import "package:flutter/services.dart";

Future<void> mediumImpact() async {
  await HapticFeedback.mediumImpact();
}

Future<void> selectionClick() async {
  await HapticFeedback.selectionClick();
}

Future<void> lightImpact() async {
  await HapticFeedback.lightImpact();
}

Future<void> heavyImpact() async {
  await HapticFeedback.heavyImpact();
}