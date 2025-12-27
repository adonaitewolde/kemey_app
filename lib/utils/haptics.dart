import "package:flutter/services.dart";



Future<void> mediumImpact() async {
  await SystemChannels.platform.invokeMethod<void>(
    'HapticFeedback.vibrate',
    'HapticFeedbackType.mediumImpact',
  );
}

Future<void> selectionClick() async {
  await SystemChannels.platform.invokeMethod<void>(
    'HapticFeedback.vibrate',
    'HapticFeedbackType.selectionClick',
  );
}